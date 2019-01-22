import Rx from 'rxjs';
import Docker from 'dockerode';
import Observable = Rx.Observable;

const docker = new Docker();

export type Container = Docker.ContainerInfo;

function container(containerId) {
    return docker.getContainer(containerId);
}

export function listRunningContainers(): Observable<Container[]> {
    return Rx.Observable.fromPromise(docker.listContainers());
}

export function listStoppedContainers(): Observable<Container[]> {
    return Rx.Observable.fromPromise(docker.listContainers({"filters": {"status": ["created", "paused", "exited", "dead"]}}));
}

export function stopContainer(containerId: string): void {
    container(containerId).stop();
}
export function startContainer(containerId: string): void {
    container(containerId).start();
}