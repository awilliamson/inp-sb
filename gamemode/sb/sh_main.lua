local GM = GM
local IsValid = IsValid

--[[---------------------------------------------------------
--	Used to confirm validity of a SB entity
 ]]
function GM:isValid( ent )
	return IsValid( ent ) and not ent:IsWorld() and IsValid(ent:GetPhysicsObject()) -- and not (ent.isNoGrav and ent:isNoGrav())
end

local types = {}
local count = 0

function GM:getResourceTypes()
	return types
end

function GM:addResourceType( name )
	if not types[name] then
		types[name] = true
		count = count + 1
	end
end

function GM:newResource( name )
	if types[name] then
		return GM.class.getClass("Resource"):new(name)
	end
end

function GM:resourceTypesCount()
	return count
end

GM:addResourceType( "Energy" )
GM:addResourceType( "Oxygen" )
GM:addResourceType( "CO2" )
GM:addResourceType( "Water" )
GM:addResourceType( "Hydrogen" )
GM:addResourceType( "Nitrogen" )
