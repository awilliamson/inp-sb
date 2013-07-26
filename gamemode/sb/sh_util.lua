local GM = GM
local print = print
local tostring = tostring
local debug = debug
local type= type
local setmetatable = setmetatable
local getmetatable = getmetatable

local util = GM.util

util.createReadOnlyTable = function(t)
	return setmetatable({}, {
		__index = t,
		__newindex = function(t, k, v)
			print("Attempt to update a read-only table")
			print(tostring(debug.traceback()))
		end,
		__metatable = false
	})
end

util.deepCopyTable = function(self, orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[self:deepCopyTable(orig_key)] = self:deepCopyTable(orig_value)
		end
		setmetatable(copy, self:deepCopyTable(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

util.tableSlice = function(values,i1,i2)
	local res = {}
	local n = #values
	-- default values for range
	i1 = i1 or 1
	i2 = i2 or n
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	if i1 < 1 or i1 > n then
		return {}
	end
	local k = 1
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	return res
end

util.smoother = function(target, current, smooth)
	return current + math.Clamp((target - current) * math.Clamp(FrameTime(), 0.0001, 10) / smooth, -1, 1)
end