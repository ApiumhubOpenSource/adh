import execa from "execa";
import {red} from "./colors";

export default action => execa.shell(action.cmd)
    .then(res => res.stdout)
    .catch(err => console.log(red("stdExec error: " + err)))