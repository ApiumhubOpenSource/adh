import {yellow} from "../../adapters/colors";
import {printBoxedBlue} from "../../adapters/box";

export default (program, runOnShell) => {
    program
        .command('nginx')
        .description(yellow("Run nginx with a volume in the current directory "))
        .option('-f, --force', 'Force remove nginx container with same name')
        .option('-p, --port <port>', 'Host port', parseInt)
        .option('-n, --name <name>', 'Container name', 'adh-nginx')
        .action(options => {
            const port = options.port ? options.port : 8888;
            const name = options.name;

            if (typeof port !== 'number' || isNaN(port)) {
                console.log(port + ' port is not a number!');
                process.exit(1);
            }

            let commands = [
                'docker run --name ' + name + ' -p ' + port + ':80 -v `pwd`:/usr/share/nginx/html:ro -d nginx'
            ];

            if (options.force) commands.unshift('docker rm -f ' + name + ' || true');

            runOnShell(commands.join('&&'), () => printBoxedBlue('Nginx running. (' + name + ':' + port + ')'))
        })
        .on('--help', () => {
            console.log('  Examples:');
            console.log();
            console.log('    $ adh nginx -p 8080 -n myNginx -f');
            console.log('    $ adh nginx -n myOtherNginx');
            console.log();
        });
}