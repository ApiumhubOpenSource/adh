import boxen from 'boxen';

function printBoxed(text: string, color: string): void {
    console.log(boxen(text, {
        padding: 1,
        borderColor: color
    }))
}

export function printBoxedBlue(text: string): void {
    printBoxed(text, "blue")
}

export function printBoxedYellow(text: string): void {
    printBoxed(text, "yellow")
}