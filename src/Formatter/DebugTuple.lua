local Debug

local DebugTuple = {}
DebugTuple.__index = DebugTuple

local function loadOrNot()
	if Debug == nil then
		Debug = require(script.Parent.Parent.Debug)
	end
end

function DebugTuple.new(name, fmt)
	loadOrNot()

	local self = setmetatable({
		fmt = fmt,
		fields = 0,
	}, DebugTuple)

	self.fmt:writeStr(name)
	self.fmt:_pushIndent()

	return self
end

function DebugTuple:field(value)
	if self.fmt.alternate then
		if self.fields == 0 then
			self.fmt:writeStr(" (\n")
		end
		self.fmt:_writeIndent()
		Debug.fromFmt(self.fmt):fmt(value)
		self.fmt:writeStr(",\n")
	else
		local prefix = if self.fields == 0 then "(" else ", "
		self.fmt:writeStr(prefix)
		Debug.fromFmt(self.fmt):fmt(value)
	end
	self.fields += 1
	return self
end

function DebugTuple:finish()
	self.fmt:_popIndent()
	if self.fields > 0 then
		if self.fields == 1 and self.fmt.alternate then
			self.fmt:writeStr(",")
		end
		self.fmt:writeStr(")")
	end
end

return DebugTuple
