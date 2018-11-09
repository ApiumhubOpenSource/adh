import Rx from 'rxjs';
import Docker from 'dockerode';
import Observable = Rx.Observable;

const docker = new Docker();

export type Container = Docker.ContainerInfo;

export function container(containerId) {
    return docker.getContainer(containerId);
}

export function listContainers(): Observable<Docker.ContainerInfo[]> {
    return Rx.Observable.fromPromise(docker.listContainers());
}

export function stopContainer(container) {
    return container.stop();
}