-- Class creation system, responsible for loading all classes and used for instantiation of objects

local GM = GM
local class = GM.class

local folder = { "classes" } -- Add another other location for classes here.
local loadedClasses = {} -- We'll use this to store our classes in.
local availableClasses = {}

local function checkClass( name )
	return availableClasses[name]
end

local function includeClass(name)

	local p = checkClass(name)
	if p ~= false then
		include(name..".lua")
		print("Included: "..name..".lua")
	end

end

function class.isLoaded(name)
	return loadedClasses[name]
end

function class.exists(name)
	return class.isLoaded(name) or checkClass(name)
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

local function preload(name)
	availableClasses[name] = true
	class.new(name)
	print("Preloaded: "..name)
end

-- Do some preloading first to get them in the table and all ready to go before they're ever called.
preload("Celestial")
preload("Resource")
preload("Environment")

preload("Icosahedron")

preload("HudComponent")
preload("HudPanel")
preload("HudBarIndicator")
preload("TextElement")
preload("HudRadialIndicator")