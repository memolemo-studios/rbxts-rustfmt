export interface DebugList {
    entry(value: unknown): DebugList;
    finish(): void;
}