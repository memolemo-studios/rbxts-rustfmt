import { OutputBuffer } from "../OutputBuffer";
import { DebugList } from "./DebugList";
import { DebugMap } from "./DebugMap";
import { DebugStruct } from "./DebugStruct";
import { DebugTuple } from "./DebugTuple";

export interface Formatter {
    readonly alternate: boolean;
    readonly buffer: OutputBuffer;

    writeStr(str: string): void;
    fmt(value: unknown): void;

    debugTuple(name: string): DebugTuple;
    debugStruct(name: string): DebugStruct;
    debugMap(): DebugMap;
    debugList(): DebugList;
}
