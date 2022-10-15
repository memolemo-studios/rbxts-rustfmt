export interface DebugMap {
    entry(key: unknown, value: unknown): DebugMap;
    key(key: unknown): DebugMap;
    value(value: unknown): DebugMap;
    finish(): void;
}