local Debug

local DebugStruct = {}
DebugStruct.__index = DebugStruct

local function loadOrNot()
    if Debug == nil then
        Debug = require(script.Parent.Parent.Debug)
    end
end

function DebugStruct.new(name, fmt)
    loadOrNot()

    local self setmetatable({
        fmt = fmt,
        hasFields = false,
    }, DebugStruct)

    self.fmt:writeStr(name)
    self.fmt:_pushIndent()

    return self
end

function DebugStruct:field(name, value)
    assert(type(name) == "string", "expected `name` to be string")
    if self.fmt.alternate then
        if self.hasFields then
            self.fmt:writeStr(" {\n")
            self.fmt:_pushIndent()
            self.fmt:_writeIndent()
        end
        self.fmt:writeStr(name)
        self.fmt:writeStr(": ")
        Debug.fromFmt(self.fmt):fmt(value)
        self.fmt:writeStr(",\n")
    else
        local prefix = if self.hasFields then ", " else " {"
        self.fmt:writeStr(prefix)
        self.fmt:writeStr(name)
        self.fmt:writeStr(": ")
        Debug.fromFmt(self.fmt):fmt(value)
    end
    self.hasFields = true
end

function DebugStruct:finishNonExhaustive()
    if self.hasFields then
        if self.fmt.alternate then
            self.fmt:_writeIndent()
            self.fmt:writeStr("..\n")
            self.fmt:_popIndent()
            self.fmt:_writeIndent()
            self.fmt:writeStr("}")
        else
            self.fmt:writeStr(" { .. }")
        end
    end
end

function DebugStruct:finish()
    if self.hasFields then
        if self.fmt.alternate then
            self.fmt:writeStr("}")
        else
            self.fmt:writeStr(" }")
        end
    end
end

return DebugStruct
