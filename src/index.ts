#!/usr/bin/env node
'use strict';
import {yellow} from './adapters/colors';
import simpleCommands from './commands/simpleCommands.json';
import pkg from '../package.json';
import runOnShell from './adapters/runOnShell';
import program from 'commander';
import {printBoxedYellow} from './adapters/box';
import {Command} from './commands/Command';
import fs from "fs";
import path from "path";

loadComplexCommands(program, runOnShell);
loadSimpleCommands(simpleCommands);
loadHelpAndVersion(pkg.version, program);


function loadHelpAndVersion(version, program) {
    program.on('*', () => {
        console.log('Unknown Command: ' + program.args.join(' '));
        program.help();
    });
    program.version(version);
    program.on('help', program.help);
    program.parse(process.argv);
}

function loadSimpleCommands(commands: Command[]): void {
    commands.forEach((command: Command) => {
        program
            .command(command.cli)
            .alias(command.alias)
            .description(yellow(command.description))
            .action(() => runOnShell(command.cmd, printBoxedYellow))
    });
}

function loadComplexCommands(program, runOnShell): void {
    const loadPath = path.dirname(__filename) + '/commands/complexCommands';

    fs.readdirSync(loadPath)
        .filter((filename: string) => filename.indexOf('cmd_') > -1 && filename.indexOf('ts') === -1)
        .map(filename => {
            const complexCommand = require(path.join(loadPath, filename)).default;
            complexCommand(program, runOnShell);
        });
}
