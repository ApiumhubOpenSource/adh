#!/usr/bin/env node
'use strict';
exports.__esModule = true;
var colors_1 = require("./adapters/colors");
var simpleCommands_json_1 = require("./commands/simpleCommands.json");
var package_json_1 = require("../package.json");
var runOnShell_1 = require("./adapters/runOnShell");
var commander_1 = require("commander");
var box_1 = require("./adapters/box");
var fs_1 = require("fs");
var path_1 = require("path");
loadComplexCommands(commander_1["default"], runOnShell_1["default"]);
loadSimpleCommands(simpleCommands_json_1["default"]);
loadHelpAndVersion(package_json_1["default"].version, commander_1["default"]);
function loadHelpAndVersion(version, program) {
    program.on('*', function () {
        console.log('Unknown Command: ' + program.args.join(' '));
        program.help();
    });
    program.version(version);
    program.on('help', program.help);
    program.parse(process.argv);
}
function loadSimpleCommands(commands) {
    commands.forEach(function (command) {
        commander_1["default"]
            .command(command.cli)
            .alias(command.alias)
            .description(colors_1.yellow(command.description))
            .action(function () { return runOnShell_1["default"](command.cmd, box_1.printBoxedYellow); });
    });
}
function loadComplexCommands(program, runOnShell) {
    var loadPath = path_1["default"].dirname(__filename) + '/commands/complexCommands';
    fs_1["default"].readdirSync(loadPath)
        .filter(function (filename) { return filename.indexOf('cmd_') > -1 && filename.indexOf('ts') === -1; })
        .map(function (filename) {
        var complexCommand = require(path_1["default"].join(loadPath, filename))["default"];
        complexCommand(program, runOnShell);
    });
}
