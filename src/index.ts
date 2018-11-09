#!/usr/bin/env node
'use strict';
import chalk from "chalk";
import complexCommands from "./commands/complexCommands/index.js";
import simpleCommands from "./commands/simpleCommands.json";
import pkg from '../package.json';
import runOnShell from "./adapters/runOnShell";
import boxen from "boxen";
import program from "commander";

complexCommands(program, runOnShell, chalk);

program.version(pkg.version);

simpleCommands.forEach(command => {
    program
        .command(command.cli)
        .alias(command.alias)
        .description(chalk.yellow(command.description))
        .action(() => {
            runOnShell({
                cmd: command.cmd,
                color: typeof command.color === 'undefined' ? true : command.color
            }).then(x => console.log(boxen(x, {padding: 1, borderColor: "yellow"})))
        })
});

program.on('*', () => {
    console.log('Unknown Command: ' + program.args.join(' '));
    program.help();
});

program.on('help', () => program.help());

program.parse(process.argv);