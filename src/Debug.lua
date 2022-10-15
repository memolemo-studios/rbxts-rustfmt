local Formatter = require(script.Parent.Formatter)

local Debug = setmetatable({}, { __index = Formatter })
Debug.__index = Debug

function Debug.new(buffer, alternate)
	local fmt = Formatter.new(buffer, alternate)
	return setmetatable(fmt, Debug)
end

function Debug.fromFmt(fmt)
	-- Clone the entire table otherwise it will
	-- be seriously modified by something
	return setmetatable(table.clone(fmt), Debug)
end

local tableStack: { [any]: number } = {}

-- https://stackoverflow.com/questions/7526223/how-do-i-know-if-a-table-is-an-array
local function isArray(tableT)   
	--has to be a table in the first place of course
	if type(tableT) ~= "table" then return false end

	--not sure exactly what this does but piFace wrote it and it catches most cases all by itself
	local piFaceTest = #tableT > 0 and next(tableT, #tableT) == nil
	if piFaceTest == false then return false end

	--must have a value for 1 to be an array
	if tableT[1] == nil then return false end

	--all keys must be integers from 1 to #tableT for this to be an array
	for k, v in pairs(tableT) do
		if type(k) ~= "number" or (k > #tableT) or(k < 1) or math.floor(k) ~= k  then return false end
	end

	--every numerical key except the last must have a key one greater
	for k,v in ipairs(tableT) do
		if tonumber(k) ~= nil and k ~= #tableT then
			if tableT[k+1] == nil then
				return false
			end
		end
	end

	--otherwise we probably got ourselves an array
	return true
end

local Types = {
	["string"] = function(fmt, value)
		local segments = value:split("\"")
		local len = #segments
		fmt:writeStr("\"")
		for i, segment in ipairs(segments) do
			fmt:writeStr(segment)
			if i ~= len then
				fmt:writeStr("\\\"")
			end
		end
		fmt:writeStr("\"")
	end,
	["table"] = function(fmt, value: { [any]: any })		
		local stackLevel = tableStack[value]
		-- to prevent stack overflow
		if stackLevel and stackLevel > 2 then
			fmt:writeStr("(cyclic reference ")
			fmt:writeStr(tostring(value))
			fmt:writeStr(")")
			return
		end
		if stackLevel == nil then
			tableStack[value] = 1
		else
			tableStack[value] += 1
		end
		-- check the metatable for __debugImpl
		local mt = getmetatable(value)
		if mt ~= nil and type(mt) == "table" then
			local success, data = pcall(function()
				return mt.__debugImpl
			end)
			if success and data ~= nil then
				data(value, fmt)
			end
		elseif isArray(value) then
			local fmt = fmt:debugList()
			for _, v in ipairs(value) do
				fmt = fmt:entry(v)
			end
			fmt:finish()
		else
			local fmt = fmt:debugMap()
			for k, v in pairs(value) do
				fmt = fmt:entry(k, v)
			end
			fmt:finish()
		end
		tableStack[value] -= 1
		if tableStack[value] == 0 then
			tableStack[value] = nil
		end
	end,
	["Instance"] = function(fmt, value)
		-- custom implementation of DebugTuple
		fmt:writeStr("Instance(")
		if fmt.alternate then
			fmt:writeStr("\n")
			fmt:_pushIndent()
			fmt:_writeIndent()
		end
		fmt:writeStr(value:GetFullName())
		if fmt.alternate then
			fmt:writeStr(",\n")
			fmt:_popIndent()
			fmt:_writeIndent()
		end
		fmt:writeStr(")")
	end,
	["Vector3"] = function(fmt, value) 
		fmt:debugStruct("Vector3")
			:field("x", value.x)
			:field("y", value.y)
			:field("z", value.z)
			:finish()
	end,
}

function Debug:fmt(value)
	local typeOf = typeof(value)
	local callback = Types[typeOf]
	if callback ~= nil then
		callback(self, value)
	else
		self.buffer:write(tostring(value))
	end
end

return Debug
