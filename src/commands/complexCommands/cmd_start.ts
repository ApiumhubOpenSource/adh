import inquirer from "inquirer";
import R from "ramda";
import {Container, listStoppedContainers, startContainer} from "../../adapters/docker";
import Listr from "listr";
import {yellow} from "../../adapters/colors";
import {printBoxedYellow} from "../../adapters/box";

export default (program, evalAction) =>
    program
        .command('start')
        .description(yellow("Start containers"))
        .option('-a, --all', 'Start all containers')
        .action(runCommand)


let run = process => new Listr(process, {concurrent: true}).run();

let startContainers = function (containers: Container[]) {
    let processes = containers.map((container: Container) => ({
        title: 'Starting ' + container.Names[0],
        task: () => startContainer(container.Id)
    }));
    run(processes);
};

let runCommand = (options) => {
            listStoppedContainers()
                .subscribe((containers: Container[]) => {

                    if (R.isEmpty(containers)) {
                        printBoxedYellow('No stopped containers');
                        return;
                    }

                    if (options.all) {
                        startContainers(containers);
                        return;
                    }

                    const tasks = [{
                            type: 'checkbox',
                            name: 'containers',
                            message: 'Select container/s to start',
                            choices: containers.map(y => ({name: y.Names[0], value: y}))
                        }];

                    inquirer
                        .prompt(tasks)
                        .then(optionsSelected => startContainers(optionsSelected['containers']));

                });
};
