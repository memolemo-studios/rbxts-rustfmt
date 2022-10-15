local OutputBuffer = require(script.OutputBuffer)

local DebugFmt = require(script.Debug)
local DisplayFmt = require(script.Display)

local function writeFmt(buffer, template: string, ...)
	local argIndex = 1
	local argsAmount = select("#", ...)

	local i = 1
	while true do
		local openBrace = template:find("{", i)
		if openBrace == nil then
			buffer:write(template:sub(i))
			break
		end

		local pos = openBrace + 1
		local charAfterBrace = template:sub(pos, pos)
		if charAfterBrace == "{" then
			buffer:write(template:sub(i, openBrace))
			i = openBrace + 2
			continue
		end

		if openBrace - i > 0 then
			buffer:write(template:sub(i, openBrace - 1))
		end

		local closeBrace = template:find("}", openBrace + 1)
		assert(closeBrace ~= nil, "Unclosed formatting specifier. Use '{{' to write an open brace.")
		
		local formatSpecifier = template:sub(openBrace + 1, closeBrace - 1)
		local selectedIndex = formatSpecifier:match("^[0-9]+") 
		if selectedIndex ~= nil then			
			-- trim off the format specifier :)
			formatSpecifier = formatSpecifier:sub(selectedIndex:len() + 1)
			selectedIndex = math.floor(assert(tonumber(selectedIndex)))
			argIndex = selectedIndex
		end
		assert(argIndex > 0, "Cannot specify argument index below 1")
		assert(argIndex <= argsAmount, string.format("Missing argument #%d", argIndex))

		local arg = select(argIndex, ...)
		local fmt
		if formatSpecifier == "" then
			fmt = DisplayFmt.new(buffer, false)
		elseif formatSpecifier == ":?" then
			fmt = DebugFmt.new(buffer, false)
		elseif formatSpecifier == ":#?" then
			fmt = DebugFmt.new(buffer, true)
		else
			error(string.format("unknown format specifier for %s", formatSpecifier))
		end
		fmt:fmt(arg)

		argIndex = argIndex + 1
		i = closeBrace + 1
	end
end

local function implDebug(tbl, debugifyFunc)
	local mt = getmetatable(tbl)
	if mt ~= nil then
		mt.__debugImpl = debugifyFunc
	else
		setmetatable(tbl, {
			__debugImpl = debugifyFunc,
		})
	end
end

local function implDisplay(tbl, displayFunc)
	local mt = getmetatable(tbl)
	if mt ~= nil then
		mt.__displayImpl = displayFunc
	else
		setmetatable(tbl, {
			__displayImpl = displayFunc,
		})
	end
end

return {
	implDebug = implDebug,
	implDisplay = implDisplay,
	fmt = function(template, ...)
		local buffer = OutputBuffer.new()
		writeFmt(buffer, template, ...)
		assert(buffer._indentLevel == 0, string.format("Leftover indentation (%d)!", buffer._indentLevel))
		return buffer:flush()
	end,
}
