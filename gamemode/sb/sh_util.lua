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