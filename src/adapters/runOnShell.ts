import execa from "execa";
import {red} from "./colors";

export default (command: string, responseMethod: (x: string) => void) => {
    execa.shell(command)
        .then(res => res.stdout)
        .catch(err => console.log(red("stdExec error: " + err)))
        .then(responseMethod);
}