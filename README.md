# @memolemo-studios/rustfmt

A partial implementation of Rust's [std::fmt](https://doc.rust-lang.org/std/fmt/index.html) for roblox-ts (in Roblox).

## Example

**roblox-ts:**
```ts
import { fmt, implDebug } from "@memolemo-studios/rustfmt";

// Should print:
// Hello Instance(Workspace)
print(fmt("{} {:?}", "Hello", game.GetService("Workspace")));

const person = {
    name: "Adam",
    age: 10,
};
implDebug(person, (value, fmt) =>
    fmt.debugStruct("Person")
        .field("name", value.name)
        .field("age", value.age)
        .finish()
);

// Should print:
// Person {
//     name: "Adam",
//     age: 10,
// }
print(fmt("{:#?}", person));
```

**Luau**:
```lua
local rustfmt = require(path.to.rustfmt)

-- Should print:
-- Hello Instance(Workspace)
print(rustfmt.fmt("{} {:?}", "Hello", game:GetService("Workspace")))

local person = {
    name = "Adam",
    age = 10,
}
rustfmt.implDebug(person, function(value, fmt)
    fmt:debugStruct("Person")
        :field("name", value.name)
        :field("age", value.age)
        :finish()
end);

-- Should print:
-- Person {
--     name: "Adam",
--     age: 10,
-- }
print(fmt("{:#?}", person))
```
