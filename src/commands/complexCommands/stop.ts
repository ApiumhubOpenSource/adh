import inquirer from "inquirer";
import R from "ramda";
import {container, listContainers, stopContainer} from "../../adapters/docker";
import boxen from "boxen";
import Listr from "listr";

let run = process => new Listr(process, {concurrent: true}).run();

let stopAllContainers = function (containers) {
    const containersToStop = containers
        .map(ctr => ({
                title: 'Stopping ' + ctr.value.Names[0],
                task: () => stopContainer(container(ctr.value.Id))
            })
        );
    run(containersToStop);
};
export default (program, evalAction, chalk) => {
    program
        .command('stop')
        .description(chalk.yellow("Stop containers"))
        .option('-a, --all', 'Stop all containers')
        .action((options) => {
            listContainers()
                .map(R.map(y => ({name: y.Names[0], value: y})))
                .subscribe(containers => {

                    if (R.isEmpty(containers)) {
                        console.log(boxen('No containers running', {padding: 1, borderColor: "yellow"}));
                        return;
                    }

                    if (options.all) {
                        stopAllContainers(containers);
                    } else {
                        const tasks = [
                            {
                                type: 'checkbox',
                                name: 'container',
                                message: 'Select container/s to stop',
                                choices: containers
                            },
                        ];
                        inquirer
                            .prompt(tasks)
                            .then(selectedContainers => {
                                const containersToStop = selectedContainers
                                    .container
                                    .map(ctr => ({
                                            title: 'Stopping ' + ctr.Names[0],
                                            task: () => stopContainer(container(ctr.Id))
                                        })
                                    );
                                run(containersToStop);
                            });
                    }
                });
        });
}