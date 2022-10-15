import { Formatter } from "./Formatter";

declare namespace rsfmt {
    export function implDebug<T extends object>(tbl: T, callback: (value: T, fmt: Formatter) => void): void;
    export function implDisplay<T extends object>(tbl: T, callback: (value: T, fmt: Formatter) => void): void;

    export function fmt(template: string, ...args: unknown[]): string;
}

export = rsfmt;
