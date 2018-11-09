import fs from "fs";
import path from "path";

export default function commandLoader(program, evalAction) {
    const loadPath = path.dirname(__filename);

    // Loop though command files and initialize each one
    fs
        .readdirSync(loadPath)
        .filter((filename: string) => filename.indexOf('cmd_') > -1 && filename.indexOf('ts') === -1)
        .map( filename => {
            // Require command
            const complexCommand = require(path.join(loadPath, filename)).default;
            // Initialize command
            complexCommand(program, evalAction);
        });
}