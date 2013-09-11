AddCSLuaFile()

DEFINE_BASECLASS("infinity_node")

ENT.PrintName = "SB Infinity Storage"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for storage entities"
ENT.Instructions = "Derive from this for anything with resource storage"

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Setup()
	self.maxstorage = {}

	self:SetupWirePorts()
end

--------------------------------------------------
-- Linking
--------------------------------------------------
function ENT:Link( node )
	if not IsValid( node ) or node:GetClass() ~= "infinity_node" then return false end
	
	self.node = node
	
	self:OnLink()
end

function ENT:Unlink()
	self:OnUnlink()
	self.node = nil
end

function ENT:IsLinked()
	return self.node ~= nil
end

--------------------------------------------------
-- Resource Handling
--------------------------------------------------
function ENT:OnLink()
	self.node:OnLinked( self )
end

function ENT:OnUnlink()
	self.node:OnUnlinked( self )
end

--------------------------------------------------
-- Other Hooks
--------------------------------------------------
function ENT:OnRemove()
	self:Unlink()
end

