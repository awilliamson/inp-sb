AddCSLuaFile()

DEFINE_BASECLASS("infinity_node")

ENT.PrintName = "SB Infinity Storage"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for storage entities"
ENT.Instructions = "Derive from this for anything with resource storage"

ENT.Spawnable = false
ENT.AdminOnly = false

if CLIENT then return end

function ENT:GetWirePorts() return {}, {} end