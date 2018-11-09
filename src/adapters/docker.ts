import Rx from 'rxjs';
import Docker from 'dockerode';

const docker = new Docker();

export function container(containerId) {
    return docker.getContainer(containerId);
}

export function listContainers() {
    return Rx.Observable.fromPromise(docker.listContainers());
}

export function stopContainer(container) {
    return container.stop();
}