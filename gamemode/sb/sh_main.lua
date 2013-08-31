local GM = GM
local IsValid = IsValid

--[[---------------------------------------------------------
--	Used to confirm validity of a SB entity
 ]]
function GM:isValid( ent )
	return IsValid( ent ) and not ent:IsWorld() and IsValid(ent:GetPhysicsObject()) and not (ent.isNoGrav and ent:isNoGrav())
end