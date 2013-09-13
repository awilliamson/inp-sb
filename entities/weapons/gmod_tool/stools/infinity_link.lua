TOOL.Category = "SB Infinity"
TOOL.Name	  = "Link Tool"
TOOL.Tab      = "SB Infinity"

if CLIENT then
	language.Add( "Tool.infinity_link.name", "Link Tool" )
	language.Add( "Tool.infinity_link.desc", "Link up resource compatible entities to nodes." )
	language.Add( "Tool.infinity_link.0", "Primary: Select all constrained entities. Secondary: Select all entities in a sphere. Scroll: Increase/decrease sphere radius, Reload: Unlink target entity from all." )
	language.Add( "Tool.infinity_link.1", "Primary: Link to node. Reload: Unselect all." )
end

TOOL.ClientConVar = {
	radius = 1000,
}

local function get_tool(ply, tool)
	-- find toolgun
	local gmod_tool = ply:GetWeapon("gmod_tool")
	if not IsValid(gmod_tool) then return end

	return gmod_tool:GetToolObject(tool)
end

local function get_active_tool(ply, tool)
	-- find toolgun
	local activeWep = ply:GetActiveWeapon()
	if not IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end

	return activeWep:GetToolObject(tool)
end

function TOOL:LeftClick(trace)
	if trace.HitWorld then return false end
	if not IsValid(trace.Entity) then return false end
	if not trace.HitPos or trace.Entity:IsPlayer() or trace.Entity:IsNPC() or (SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone )) then return false end
	if CLIENT then return true end
	
	local ent = trace.Entity
	if self:GetStage() == 0 then
		if not constraint.HasConstraints( ent ) then return false end
		
		local sel = constraint.GetAllConstrainedEntities( ent )
		for k,v in pairs( sel ) do
			trace.Entity = v
			if not hook.Run( "CanTool", self:GetOwner(), trace, "infinity_link" ) then continue end
			self:Select( v )
		end

		self:SetStage(1)
		return true
	elseif self:GetStage() == 1 then
		if trace.Entity:GetClass() == "infinity_node" then
			self:Link( trace.Entity )
			self:Holster()
		else
			self:GetOwner():ChatPrint( "[SB Infinity Link] That is not a node!" )
		end
	end
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	if self:GetStage() == 0 then
		local radius = self:GetClientNumber( "radius", 1000 )
		
		local sel = ents.FindInSphere( trace.HitPos, radius )
		for k,v in pairs( sel ) do
			trace.Entity = v
			if not hook.Run( "CanTool", self:GetOwner(), trace, "shipconstraint" ) then continue end
			if v:IsPlayer() or v:IsNPC() or not util.IsValidPhysicsObject( v, 0 ) then continue end
			self:Select( v )
		end
		
		self:SetStage(1)
		return true
	end
end

function TOOL:Reload( trace )
	if CLIENT then return true end
	if self:GetStage() == 0 then
		if IsValid(trace.Entity) and trace.Entity:GetClass() == "infinity_node" then
			trace.Entity:UnlinkAll()
		else
			self:GetOwner():ChatPrint( "[SB Infinity Link] That is not a node!" )
		end
	elseif self:GetStage() == 1 then
		self:Holster()
	end
	return true
end

function TOOL:Holster()
	if CLIENT then return true end
	for ent,clr in pairs( self.Selected ) do
		ent:SetColor( clr )
	end
	
	self.Selected = {}
	self:SetStage( 0 )
end

if SERVER then
	TOOL.Selected = {}
	function TOOL:Select( ent )
		if ent:GetClass():sub( 1, 9 ) ~= "infinity_" then return false end
		if not self.Selected[ent] then
			self.Selected[ent] = ent:GetColor()
			ent:SetColor( Color(0,200,0,255) )
		else
			if self.Selected[ent] then
				ent:SetColor( self.Selected[ent] )
			end
			self.Selected[ent] = nil
		end
	end
	
	function TOOL:Link( node )
		for ent, clr in pairs( self.Selected ) do
			if not IsValid(ent) or ent == node then continue end
			ent:Link( node )
		end
	end

elseif CLIENT then
	function TOOL:Scroll(trace,dir)
		RunConsoleCommand("infinity_link_radius",self:GetClientNumber("radius",1000)+100*dir)
		LocalPlayer():ChatPrint( "[SB Infinity Link] Radius set to: " .. self:GetClientNumber("radius",1000) )
		return true
	end
	
	function TOOL:ScrollUp(trace) return self:Scroll(trace,1) end
	function TOOL:ScrollDown(trace) return self:Scroll(trace,-1) end
	
	local function hookfunc( ply, bind, pressed )
		if not pressed then return end
	
		if bind == "invnext" then
			local self = get_active_tool(ply, "infinity_link")
			if not self then return end
			
			return self:ScrollDown(ply:GetEyeTraceNoCursor())
		elseif bind == "invprev" then
			local self = get_active_tool(ply, "infinity_link")
			if not self then return end
			
			return self:ScrollUp(ply:GetEyeTraceNoCursor())
		end
	end
	
	if game.SinglePlayer() then -- wtfgarry (have to have a delay in single player or the hook won't get added)
		timer.Simple(5,function() hook.Add( "PlayerBindPress", "infinity_link_playerbindpress", hookfunc ) end)
	else
		hook.Add( "PlayerBindPress", "infinity_link_playerbindpress", hookfunc )
	end
	
	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool.infinity_link.name", Description = "#Tool.infinity_link.desc" })
		
		panel:NumSlider("Radius", "infinity_link_radius", 0, 5000, 1)
	end
end