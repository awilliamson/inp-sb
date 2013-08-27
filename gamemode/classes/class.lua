-- Class creation system, responsible for loading all classes and used for instantiation of objects

local GM = GM
local class = GM.class
local AddCSLuaFile = AddCSLuaFile

AddCSLuaFile()

local folder = { "classes" } -- Add another other location for classes here.
local loadedClasses = {} -- We'll use this to store our classes in.

local clientTbl = { --Add the files for classes used on the client here
	"Celestial.lua",
	"Environment.lua",
	"Icosahedron.lua",
	"Resource.lua",
	"HudComponent.lua",
	"HudPanel.lua",
	"HudBarIndicator.lua",
	"TextElement.lua",
	"HudRadialIndicator.lua"
}

if SERVER then
	MsgN("--Sending clientside classes--")
	for _,v in pairs(clientTbl) do
		MsgN("File sent: "..v)
		AddCSLuaFile(v)
	end
	MsgN("--Finished sending classes--")
end

local function checkClass( name )
	return table.HasValue(clientTbl, name..".lua")
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