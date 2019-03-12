"use strict";
exports.__esModule = true;
var execa_1 = require("execa");
var colors_1 = require("./colors");
exports["default"] = (function (command, responseMethod) {
    execa_1["default"].shell(command)
        .then(function (res) { return res.stdout; })["catch"](function (err) { return console.log(colors_1.red("stdExec error: " + err)); })
        .then(responseMethod);
});
