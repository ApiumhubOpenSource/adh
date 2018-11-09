#!/usr/bin/env node
'use strict';
import {yellow} from "./adapters/colors";
import loadComplexCommands from "./commands/complexCommands/commandLoader";
import simpleCommands from "./commands/simpleCommands.json";
import pkg from '../package.json';
import runOnShell from "./adapters/runOnShell";
import program from "commander";
import {printBoxedYellow} from "./adapters/box";

loadComplexCommands(program, runOnShell);

program.version(pkg.version);

simpleCommands.forEach(command => {
    program
        .command(command.cli)
        .alias(command.alias)
        .description(yellow(command.description))
        .action(() => {
            runOnShell({
                cmd: command.cmd,
                color: typeof command.color === 'undefined' ? true : command.color
            }).then((x: string) => printBoxedYellow(x))
        })
});

program.on('*', () => {
    console.log('Unknown Command: ' + program.args.join(' '));
    program.help();
});

program.on('help', () => program.help());

program.parse(process.argv);