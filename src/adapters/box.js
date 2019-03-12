"use strict";
exports.__esModule = true;
var boxen_1 = require("boxen");
function printBoxed(text, color) {
    console.log(boxen_1["default"](text, {
        padding: 1,
        borderColor: color
    }));
}
function printBoxedBlue(text) {
    printBoxed(text, "blue");
}
exports.printBoxedBlue = printBoxedBlue;
function printBoxedYellow(text) {
    printBoxed(text, "yellow");
}
exports.printBoxedYellow = printBoxedYellow;
