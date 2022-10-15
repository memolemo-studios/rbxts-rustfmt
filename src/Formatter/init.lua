local DebugStruct = require(script.DebugStruct)
local DebugMap = require(script.DebugMap)
local DebugTuple = require(script.DebugTuple)
local DebugList = require(script.DebugList)

local Formatter = {}
Formatter.__index = Formatter

function Formatter.new(buffer, alternate)
	return setmetatable({
		alternate = alternate,
		buffer = buffer,
	}, Formatter)
end

function Formatter:writeStr(data)
	self.buffer:write(data)
end

function Formatter:_pushIndent()
	self.buffer:pushIndent()
end

function Formatter:_popIndent()
	self.buffer:popIndent()
end

function Formatter:_writeIndent()
	self.buffer:writeIndent()
end

function Formatter:_writeNewLine()
	self.buffer:writeNewLine()
end

function Formatter:fmt()
	error("Not implemented")
end

function Formatter:debugTuple(name)
	return DebugTuple.new(name, self)
end

function Formatter:debugStruct(name)
	return DebugStruct.new(name, self)
end

function Formatter:debugMap()
	return DebugMap.new(self)
end

function Formatter:debugList()
	return DebugList.new(self)
end

return Formatter
