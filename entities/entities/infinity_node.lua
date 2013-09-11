AddCSLuaFile()

DEFINE_BASECLASS("base_wire_entity")

ENT.PrintName = "SB Infinity Node"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for resource entities"
ENT.Instructions = "node"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("infinity_node")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50) )
		ent:SetModel("models/hunter/blocks/cube05x05x05.mdl")
		ent:Spawn()
		ent:Setup()
	end

	return ent
end


--------------------------------------------------
-- Init & Setup
--------------------------------------------------
function ENT:Initialize()
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	end
end

function ENT:Setup()

	self:SetupWirePorts()
	self.storage = {}
	self.maxstorage = {}
	
end


--------------------------------------------------
-- Wiring
--------------------------------------------------
function ENT:GetWirePorts()
	return {}, {}
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
end

--------------------------------------------------
-- Resource Handling
--------------------------------------------------
function ENT:OnLinked( ent )
	self:IncreaseMaxStorage( ent:GetMaxStorage() )
end

function ENT:OnUnlinked( ent )
	local resources = ent:GetMaxStorage()
	
	for name,amount in pairs( resources ) do
		self:ConsumeResource( name, amount )
	end
	
	self:DecreaseMaxStorage( resources )
end

function ENT:IncreaseMaxStorage( storage )
	if self.node then return self.node:IncreaseMaxStorage( storage ) end
	
	for name,amount in pairs( storage ) do
		self:SetMaxAmount( name, (self:GetMaxAmount( name ) or 0) + amount )
	end
end

function ENT:DecreaseMaxStorage( storage )
	if self.node then return self.node:DecreaseMaxStorage( storage ) end
	
	for name,amount in pairs( storage ) do
		if self:HasResource( name ) then
			self:SetMaxAmount( name, self:GetMaxAmount( name ) - amount )
		end
	end
end

function ENT:HasResource( name )
	if self.node then return self.node:HasResource( name ) end
	
	return self.maxstorage[name] ~= nil
end

function ENT:GetAmount( name )
	if self.node then return self.node:GetAmount( name ) end
	
	return self.storage[name]
end

function ENT:SetAmount( name, amount )
	if self.node then return self.node:SetAmount( name, amount ) end
	
	self.storage[name] = math.min( amount, self:GetMaxAmount( name ) )
end

function ENT:GetMaxAmount( name )
	if self.node then return self.node:GetMaxAmount( name ) end
	
	return self.maxstorage[name]
end

function ENT:SetMaxAmount( name, amount )
	if self.node then return self.node:SetMaxAmount( name, amount ) end
	
	self.maxstorage[name] = math.max((self.maxstorage[name] or 0) - amount,0)
	if self.maxstorage[name] == 0 then self.maxstorage[name] = nil end
end

function ENT:ConsumeResource( name, amount )
	if self.node then return self.node:ConsumeResource( name, amount ) end
	
	if not self:HasStorage( name ) then return false end

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
	
	if not self:HasResource( name ) then return false end
	
	local max_amount = self:GetMaxAmount( name )
	local current_amount = self:GetAmount( name )
	
	self:SetAmount( name, current_amount + amount )
		
	if current_amount + amount <= max_amount then
		return true, 0
	else
		return true, max_amount - (current_amount + amount)
	end
end

function ENT:GetMaxStorage()
	return self.maxstorage or {}
end

function ENT:SetMaxStorage( storage )
	self.maxstorage = storage
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