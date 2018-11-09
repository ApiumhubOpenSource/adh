import inquirer from "inquirer";
import R from "ramda";
import {container, listContainers, stopContainer} from "../../adapters/docker";
import Listr from "listr";
import {yellow} from "../../adapters/colors";
import {printBoxedYellow} from "../../adapters/box";

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
export default (program, evalAction) => {
    program
        .command('stop')
        .description(yellow("Stop containers"))
        .option('-a, --all', 'Stop all containers')
        .action((options) => {
            listContainers()
                .map(R.map(y => ({name: y.Names[0], value: y})))
                .subscribe(containers => {

                    if (R.isEmpty(containers)) {
                        printBoxedYellow('No containers running');
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
                                    ['container']
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