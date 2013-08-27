AddCSLuaFile()

DEFINE_BASECLASS("infinity_base_resource")

ENT.PrintName = "Base Resource Generator"
ENT.Author = "Radon"
ENT.Contact = "sb@inp.io"
ENT.Purpose = "Base for resource generation"
ENT.Instructions = "Derive from this for anything with resource storage/generation"

ENT.Spawnable = false
ENT.AdminOnly = false

-- Init register ( use ENUM )

-- Hook onto draw for world/hud tips

-- Off/On methods + Toggle

-- Restore support & GarryDupe