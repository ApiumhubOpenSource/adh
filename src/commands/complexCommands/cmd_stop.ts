import inquirer from "inquirer";
import R from "ramda";
import {Container, listContainers, stopContainer} from "../../adapters/docker";
import Listr from "listr";
import {yellow} from "../../adapters/colors";
import {printBoxedYellow} from "../../adapters/box";

export default (program, evalAction) =>
    program
        .command('stop')
        .description(yellow("Stop containers"))
        .option('-a, --all', 'Stop all containers')
        .action(runCommand)


let run = process => new Listr(process, {concurrent: true}).run();

let stopContainers = function (containers: Container[]) {
    let processes = containers.map((container: Container) => ({
        title: 'Stopping ' + container.Names[0],
        task: () => stopContainer(container.Id)
    }));
    run(processes);
};

let runCommand = (options) => {
            listContainers()
                .subscribe((containers: Container[]) => {

                    if (R.isEmpty(containers)) {
                        printBoxedYellow('No containers running');
                        return;
                    }

                    if (options.all) {
                        stopContainers(containers);
                        return;
                    }

                    const tasks = [{
                            type: 'checkbox',
                            name: 'containers',
                            message: 'Select container/s to stop',
                            choices: containers.map(y => ({name: y.Names[0], value: y}))
                        }];

                    inquirer
                        .prompt(tasks)
                        .then(optionsSelected => stopContainers(optionsSelected['containers']));

                });
};
