export interface DebugStruct {
    field(key: string, value: unknown): DebugStruct;
    finishNonExhaustive(): void;
    finish(): void;
}