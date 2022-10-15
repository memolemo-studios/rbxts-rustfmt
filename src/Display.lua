local Formatter = require(script.Parent.Formatter)

local Display = setmetatable({}, { __index = Formatter })
Display.__index = Display

function Display.new(buffer)
	local fmt = Formatter.new(buffer, false)
	return setmetatable(fmt, Display)
end

local Types = {}

function Display:fmt(value)
	local typeOf = typeof(value)
	local callback = Types[typeOf]
	if callback ~= nil then
		callback(self, value)
	else
		self.buffer:write(tostring(value))
	end
end

return Display
