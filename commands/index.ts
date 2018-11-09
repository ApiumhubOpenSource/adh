import fs from "fs";
import path from "path";

export default function commandLoader(program, evalAction, chalk) {
    const loadPath = path.dirname(__filename);

    // Loop though command files and initialize each one
    fs
        .readdirSync(loadPath)
        .filter(filename => (/\.ts$/.test(filename) && !/\.d.ts$/.test(filename) && filename !== 'index.ts'))
        .map( filename => {
            // Require command
            const complexCommand = require(path.join(loadPath, filename));
            // Initialize command
            complexCommand(program, evalAction, chalk);
        });
}