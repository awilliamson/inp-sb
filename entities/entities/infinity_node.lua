AddCSLuaFile()

DEFINE_BASECLASS("base_wire_entity")

ENT.PrintName = "SB Infinity Node"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for resource entities"
ENT.Instructions = "node"

ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then return end

function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("infinity_node")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50) )
		ent:SetModel("models/hunter/blocks/cube05x05x05.mdl")
		ent:Spawn()
	end

	return ent
end


--------------------------------------------------
-- Init & Setup
--------------------------------------------------
function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:Setup()
end

function ENT:Setup()
	local storage = {}
	
	for name,_ in pairs( GAMEMODE:getResourceTypes() ) do
		storage[name] = GAMEMODE:newResource( name )
	end

	self:SetStorage( storage )

	self:SetupWirePorts()
	self:UpdateOutputs()
end


--------------------------------------------------
-- Wiring
--------------------------------------------------
function ENT:GetWirePorts()
	local inputs, outputs = {}, {}
	for name, _ in pairs( self:GetStorage() ) do
		outputs[#outputs+1] = name
		outputs[#outputs+1] = "Max " .. name
		inputs[#inputs+1] = "Vent " .. name
	end
	return inputs, outputs
end

function ENT:SetupWirePorts()
	local inputs, outputs = self:GetWirePorts()
	if inputs and #inputs > 0 then
		WireLib.CreateInputs( self, inputs )
	end
	
	if outputs and #outputs > 0 then
		WireLib.CreateOutputs( self, outputs )
	end
end

function ENT:UpdateOutputs()
	for name, _ in pairs( self:GetStorage() ) do
		WireLib.TriggerOutput( self, name, self:GetAmount( name ) )
		WireLib.TriggerOutput( self, "Max " .. name, self:GetMaxAmount( name ) )
	end
end

--------------------------------------------------
-- Linking
--------------------------------------------------
function ENT:Link( node )
	if not IsValid( node ) or node:GetClass() ~= "infinity_node" then return false end
	
	-- Check for infinite loops
	local current_node = node.node
	while true do
		if not IsValid( current_node ) then break end
		if current_node == self then return false end
		current_node = current_node.node
	end
	
	if self:IsLinked() then
		self:Unlink()
	end
	
	self.node = node
	
	self:OnLink()
end

function ENT:Unlink()
	if not self:IsLinked() then return end

	self:OnUnlink()
	self.node = nil
end

function ENT:IsLinked()
	return self.node ~= nil
end

function ENT:OnLink()
	--if self.node then self.node:OnLinked( self ) return end
	
	self:OnLinked( self )
end

function ENT:OnUnlink()
	--if self.node then self.node:OnUnlinked( self ) return end
	
	self:OnUnlinked( self )
end

--------------------------------------------------
-- Resource Handling
--------------------------------------------------
function ENT:OnLinked( ent )
	local resources = ent:GetStorage()
	if resources and next(resources) ~= nil then
		
		self:IncreaseMaxStorage( ent:GetStorage() )
		
	end
end

function ENT:OnUnlinked( ent )
	local resources = ent:GetStorage()
	if resources and next(resource) ~= nil then
	
		for name,resource in pairs( resources ) do
			self:ConsumeResource( name, math.min( self:GetAmount( name ), resource:getMaxAmount() ) )
		end
		
		self:DecreaseMaxStorage( resources )
		
	end
end


-------------------------
-- Checks
-------------------------
function ENT:GetResource( name )
	if self.node then return self.node:GetResource( name ) end
	
	return self.storage[name]
end


-------------------------
-- Increase/DecreaseMaxStorage
-------------------------

function ENT:IncreaseMaxStorage( storage )
	if self.node then return self.node:IncreaseMaxStorage( storage ) end
	
	for name,resource in pairs( storage ) do
		self:SetMaxAmount( name, self:GetMaxAmount( name ) + resource:getMaxAmount( name ) )
	end
end

function ENT:DecreaseMaxStorage( storage )
	if self.node then return self.node:DecreaseMaxStorage( storage ) end
	
	for name,resource in pairs( storage ) do
		self:SetMaxAmount( name, self:GetMaxAmount( name ) - resource:getMaxAmount( name ) )
	end
end



-------------------------
-- Get/SetAmount
-------------------------

function ENT:GetAmount( name )
	if self.node then return self.node:GetAmount( name ) end
	
	return self:GetResource( name ):getAmount()
end

function ENT:SetAmount( name, amount )
	if self.node then return self.node:SetAmount( name, amount ) end
	
	local resource = self:GetResource( name )
	resource:setAmount( math.min( amount, resource:getMaxAmount() ) )
end

function ENT:GetMaxAmount( name )
	if self.node then return self.node:GetMaxAmount( name ) end
	
	return self:GetResource( name ):getMaxAmount()
end

function ENT:SetMaxAmount( name, amount )
	if self.node then return self.node:SetMaxAmount( name, amount ) end
	
	self:GetResource( name ):setMaxAmount( math.max( amount, 0 ) )
end


-------------------------
-- Supply/ConsumeResource
-------------------------

function ENT:ConsumeResource( name, amount )
	if self.node then return self.node:ConsumeResource( name, amount ) end
	
	if not self:GetResource( name ) then return false end

	local current_amount = self:GetAmount( name )
		
	if current_amount >= amount then
		self:SetAmount( name, current_amount - amount )
		return true
	else
		return false, amount - current_amount
	end
end

function ENT:SupplyResource( name, amount )
	if self.node then return self.node:SupplyResource( name, amount ) end
	
	if not self:GetResource( name ) then return false end
	
	local max_amount = self:GetMaxAmount( name )
	local current_amount = self:GetAmount( name )
	
	self:SetAmount( name, current_amount + amount )
		
	if current_amount + amount <= max_amount then
		return true, 0
	else
		return true, max_amount - (current_amount + amount)
	end
end

-------------------------
-- Get/SetStorage
-------------------------

function ENT:GetStorage()
	return self.storage
end

function ENT:SetStorage( storage )
	self.storage = storage
end

--------------------------------------------------
-- Other Hooks
--------------------------------------------------
function ENT:OnRemove()
	self:Unlink()
end

function ENT:Think()
	self:UpdateOutputs()
	self:NextThink( CurTime() + 1 )
	return true
end