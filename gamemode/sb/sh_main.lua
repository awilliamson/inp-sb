local GM = GM
local IsValid = IsValid

--[[---------------------------------------------------------
--	Used to confirm validity of a SB entity
 ]]
function GM:isValid( ent )
	return IsValid( ent ) and not ent:IsWorld() and IsValid(ent:GetPhysicsObject()) -- and not (ent.isNoGrav and ent:isNoGrav())
end

local types = {
	["Energy"] = true,
	["Oxygen"] = true,
	["CO2"] = true,
	["Water"] = true,
	--["Heavy Water"] = true,
	["Hydrogen"] = true,
	["Nitrogen"] = true,
}

function GM:getResourceTypes()
	return types
end

function GM:addResourceType( name )
	if not types[name] then
		types[name] = true
	end
end

function GM:newResource( name )
	if types[name] then
		return GM.class.getClass("Resource"):new(name)
	end
end

