local Debug

local DebugList = {}
DebugList.__index = DebugList

local function loadOrNot()
	if Debug == nil then
		Debug = require(script.Parent.Parent.Debug)
	end
end

function DebugList.new(fmt)
	loadOrNot()

	local self = setmetatable({
		fmt = fmt,
		fields = 0,
	}, DebugList)

	self.fmt:writeStr("[")

	return self
end

function DebugList:entry(value)
	if self.fmt.alternate then
		if self.fields == 0 then
			self.fmt:writeStr("\n")
			self.fmt:_pushIndent()
		end
		self.fmt:_writeIndent()
		Debug.fromFmt(self.fmt):fmt(value)
		self.fmt:writeStr(",\n")
	else
		if self.fields > 0 then
			self.fmt:writeStr(",")	
		end
		Debug.fromFmt(self.fmt):fmt(value)
	end
	self.fields += 1
	return self
end

function DebugList:finish()
	if self.fields > 0 then
		if self.fmt.alternate then
			self.fmt:_popIndent()
		end
	end
	self.fmt:writeStr("]")
end

return DebugList
