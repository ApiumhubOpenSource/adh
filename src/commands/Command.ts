export interface Command {
    cli: string,
    alias?: string,
    cmd: string,
    description: string,
    color?: boolean
}