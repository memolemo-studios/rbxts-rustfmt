export interface DebugTuple {
    field(value: unknown): DebugTuple;
    finish(): void;
}