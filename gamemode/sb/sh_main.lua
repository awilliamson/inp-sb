local GM = GM
local IsValid = IsValid

--[[---------------------------------------------------------
--	Used to confirm validity of a SB entity
 ]]
function GM:isValid( ent )
	return IsValid( ent ) and not ent:IsWorld() and IsValid(ent:GetPhysicsObject()) -- and not (ent.isNoGrav and ent:isNoGrav())
end

local types = {}
function GM:defineResourceType( o )
	if o.is_A and o:is_A(GM.class.getClass("Resource")) then
		-- The object is a valid resource
		types[o:getName()] = o
		return true
	end
	return false
end

function GM:getResourceType(s)
	return types[s] or nil
end

-- Let's define some custom types ourselves :D
GM:defineResourceType( GM.class.getClass("Resource"):new("Energy") )
GM:defineResourceType( GM.class.getClass("Resource"):new("Oxygen") )
GM:defineResourceType( GM.class.getClass("Resource"):new("CO2") )
GM:defineResourceType( GM.class.getClass("Resource"):new("Water") )
GM:defineResourceType( GM.class.getClass("Resource"):new("Heavy Water") )
GM:defineResourceType( GM.class.getClass("Resource"):new("Hydrogen") )
GM:defineResourceType( GM.class.getClass("Resource"):new("Nitrogen") )

