-- Class creation system, responsible for loading all classes and used for instantiation of objects

local GM = GM
local class = GM.class

local folder = { "classes" } -- Add another other location for classes here.
local loadedClasses = {} -- We'll use this to store our classes in.

local function checkClass( name )

	for k,v in pairs(folder) do
		-- For each location classes can exist in

		local tbl = string.Explode("/", debug.getinfo(1).source:sub(2) )
		table.remove(tbl)
		table.remove(tbl)
		tbl = table.concat(tbl,"/")

		local path = tbl.."/"..v.."/"..name..".lua"

		local f,_ = file.Find(path,"GAME")
		if #f == 1 then -- If we've found the lua file responsible for the Class
			return v
		end
	end
	return false -- Otherwise it doesn't exist

end

local function includeClass(name)

	local p = checkClass(name)
	if p ~= false then
		include(name..".lua")--"../"..p.."/"..name..".lua")
		print("Included: "..name..".lua")
	end

end

function class.isLoaded(name)
	return loadedClasses[name]
end

function class.exists(name)
	return class.isLoaded(name) or checkClass(name) ~= false
end

function class.new(name, ...)
	if type(name) ~= "string" then name = tostring(name) end

	if not class.isLoaded(name) then

		if not class.exists(name) then
			error("Class, ".. name .." not found")
			return
		end

		includeClass(name)

	else
		return loadedClasses[name]:new(...)
	end
end

function class.registerClass(name, classTable )
	if not class.isLoaded(name) and class.exists(name) then
		loadedClasses[name] = classTable
	end
end

function class.registerPath( path )
	table.insert(loadedClasses, path)
end

function class.getClass( name )
	return class.isLoaded( name )
end

-- Do some preloading first to get them in the table and all ready to go before they're ever called.
class.new("Celestial")
class.new("Resource")
class.new("Environment")

class.new("Icosahedron")

class.new("HudComponent")
class.new("HudPanel")
class.new("HudBarIndicator")
class.new("TextElement")
class.new("HudRadialIndicator")