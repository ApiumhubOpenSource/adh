import chalk from "chalk";
import execa from "execa";

export default action => execa.shell(action.cmd)
    .then(res => res.stdout)
    .catch(err => console.log(chalk.red("stdExec error: " + err)))