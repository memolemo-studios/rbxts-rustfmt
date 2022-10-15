local Debug

local DebugMap = {}
DebugMap.__index = DebugMap

local function loadOrNot()
	if Debug == nil then
		Debug = require(script.Parent.Parent.Debug)
	end
end

function DebugMap.new(fmt)
	loadOrNot()

	local self = setmetatable({
		fmt = fmt,
		hasFields = false,
		hasKey = false,
	}, DebugMap)

	self.fmt:writeStr("{")
	self.fmt:_pushIndent()

	return self
end

function DebugMap:entry(key, value)
	return self:key(key):value(value)
end

function DebugMap:key(key)
	assert(not self.hasKey, "Attempted to begin a new map entry without completing the previous one")
	if self.fmt.alternate then
		if not self.hasFields then
			self.fmt:writeStr("\n")
		end
		self.fmt:_writeIndent()
		Debug.fromFmt(self.fmt):fmt(key)
		self.fmt:writeStr(": ")
	else
		if self.hasFields then
			self.fmt:writeStr(", ")
		end
		Debug.fromFmt(self.fmt):fmt(key)
		self.fmt:writeStr(": ")
	end
	self.hasKey = true
	self.hasFields = true
	return self
end

function DebugMap:value(value)
	assert(self.hasKey, "Attempted to format a map value before its key")
	if self.fmt.alternate then
		Debug.fromFmt(self.fmt):fmt(value)
		self.fmt:writeStr(",\n")
	else
		Debug.fromFmt(self.fmt):fmt(value)
	end
	self.hasKey = false
	return self
end

function DebugMap:finish()
	assert(not self.hasKey, "Attempted to finish a map with a partial entry")
	self.fmt:_popIndent()
	if self.fmt.alternate then
		self.fmt:_writeIndent()
	end
	self.fmt:writeStr("}")
end

return DebugMap
