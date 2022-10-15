export interface OutputBuffer {
    pushIndent(): void;
    popIndent(): void;
    write(str: string): void;
    writeNewLine(): void;
    flush(): string;
}
