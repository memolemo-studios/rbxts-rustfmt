local OutputBuffer = {}
OutputBuffer.__index = OutputBuffer

function OutputBuffer.new()
	return setmetatable({
		_buffer = {},
		_indentation = "",
		_indentLevel = 0,
	}, OutputBuffer)
end

function OutputBuffer:pushIndent()
	local indentLevel = self._indentLevel + 1
	self._indentLevel = indentLevel
	self._indentation = string.rep("    ", self._indentLevel)
end

function OutputBuffer:popIndent()
	local indentLevel = math.max(0, self._indentLevel - 1)
	self._indentLevel = indentLevel
	self._indentation = string.rep("    ", indentLevel)
end

function OutputBuffer:write(value)
	table.insert(self._buffer, value)
end

function OutputBuffer:writeIndent()
	table.insert(self._buffer, self._indentation)
end

function OutputBuffer:writeNewLine()
	table.insert(self._buffer, "\n")
end

function OutputBuffer:flush()
	return table.concat(self._buffer, "")
end

return OutputBuffer
