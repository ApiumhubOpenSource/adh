import Rx from 'rxjs';
import Docker from 'dockerode';
import Observable = Rx.Observable;

const docker = new Docker();

export type Container = Docker.ContainerInfo;

function container(containerId) {
    return docker.getContainer(containerId);
}

export function listContainers(): Observable<Container[]> {
    return Rx.Observable.fromPromise(docker.listContainers());
}

export function stopContainer(containerId: string): void {
    container(containerId).stop();
}