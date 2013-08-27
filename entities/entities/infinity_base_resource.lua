AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Base Resource Entity"
ENT.Author = "Radon"
ENT.Contact = "sb@inp.io"
ENT.Purpose = "Base for resource entities"
ENT.Instructions = "Derive from this for anything with resource storage/generation"

ENT.Spawnable = false
ENT.AdminOnly = false

-- Register device on INIT

-- Add functions for add/remove of resources

-- Add dupe support
-- Especially garrydupe