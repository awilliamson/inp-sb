AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

local GM = GAMEMODE

ENT.PrintName = "Infinity Planet"
ENT.Author = "Radon"
ENT.Contact = "sb@inp.io"

ENT.celestial = nil -- This refers to what will be the parent object which houses env and ent data

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Initialize()
	if SERVER then

		self:SetModel("models/props_lab/huladoll.mdl")

		self:SetMoveType( MOVETYPE_NONE ) -- We don't want these planets to move
		self:SetSolid( SOLID_NONE ) -- We want people to be able to pass through it...

		--self:PhysicsFromMesh( GM.class.getClass("Icosahedron"):new(), false )

		self:PhysicsInitSphere( 1 ) -- Create a standard physics sphere
		self:SetCollisionBounds( Vector(-1,-1,-1), Vector(1,1,1) )

		--self:PhysicsFromMesh( GM.class.getClass("Icosahedron"):new(), true )

		self:SetTrigger( true ) -- Make sure this is true otherwise startTouch and endTouch won't fire!
		self:GetPhysicsObject():EnableMotion( false ) -- DON'T MOVE!
		self:DrawShadow( false ) -- That would be bad.

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self:SetNotSolid( true )

		--self:EnableCustomCollisions()
		--self:SetCustomCollisionCheck(true)

	end

	if CLIENT then
		self.mesh = Mesh()
		local meshexample = {}
		local p = (1 + math.sqrt(5)) / 2

		local t = {
			Vector(-1, p, 0):GetNormalized(),	-- P0 t[1]
			Vector(1, p, 0):GetNormalized(),	-- P1 t[2]
			Vector(-1, -p, 0):GetNormalized(),	-- P2 t[3]
			Vector(1, -p, 0):GetNormalized(),	-- P3 t[4]

			Vector(0, -1, p):GetNormalized(),	-- P4 t[5]
			Vector(0, 1, p):GetNormalized(),	-- P5 t[6]
			Vector(0, -1, -p):GetNormalized(),	-- P6 t[7]
			Vector(0, 1, -p):GetNormalized(),	-- P7 t[8]

			Vector(p, 0, -1):GetNormalized(),	-- P8 t[9]
			Vector(p, 0, 1):GetNormalized(),	-- P9 t[10]
			Vector(-p, 0, -1):GetNormalized(),	-- P10 t[11]
			Vector(-p, 0, 1):GetNormalized()	-- P11 t[12]
		}

		-- P0, P1, P5
		meshexample[1] = { pos = t[1], normal = t[1], u=0, v=0  }
		meshexample[2] = { pos = t[2],normal = t[2], u=0, v=0  }
		meshexample[3] = { pos = t[6], normal = t[6], u=0, v=0 }

		-- P0, P7, P1
		meshexample[4] = { pos = t[1],normal = t[1], u=0, v=0  }
		meshexample[5] = { pos = t[8], normal = t[8], u=0, v=0  }
		meshexample[6] = { pos = t[2], normal = t[2],  u=0, v=0 }

		-- P0, P10, P7
		meshexample[7] = { pos = t[1], normal = t[1],  u=0, v=0 }
		meshexample[8] = { pos = t[11], normal = t[11],  u=0, v=0 }
		meshexample[9] = { pos = t[8], normal = t[8],  u=0, v=0 }

		-- P0, P11, P10
		meshexample[10] = { pos = t[1], normal = t[1],  u=0, v=0 }
		meshexample[11] = { pos = t[12], normal = t[12],  u=0, v=0 }
		meshexample[12] = { pos = t[11], normal = t[11],  u=0, v=0 }

		-- P0, P5, P11
		meshexample[13] = { pos = t[1], normal = t[1],  u=0, v=0 }
		meshexample[14] = { pos = t[6], normal = t[6],  u=0, v=0 }
		meshexample[15] = { pos = t[12], normal = t[12],  u=0, v=0 }

		-- TOP 5 TRI DONE!

		-- BEGIN MIDDLE 10!

		-- P11, P5, P4
		meshexample[16] = { pos = t[12], normal = t[12],  u=0, v=0 }
		meshexample[17] = { pos = t[6], normal = t[6],  u=0, v=0 }
		meshexample[18] = { pos = t[5], normal = t[5],  u=0, v=0 }

		-- P5, P9, P4
		meshexample[19] = { pos = t[6], normal = t[6],  u=0, v=0 }
		meshexample[20] = { pos = t[10], normal = t[10],  u=0, v=0 }
		meshexample[21] = { pos = t[5], normal = t[5],  u=0, v=0 }

		-- P5, P1, P9
		meshexample[22] = { pos = t[6], normal = t[6],  u=0, v=0 }
		meshexample[23] = { pos = t[2],normal = t[2], u=0, v=0  }
		meshexample[24] = {  pos = t[10], normal = t[10],  u=0, v=0 }

		-- P1, P8, P9
		meshexample[25] = { pos = t[2],normal = t[2], u=0, v=0 }
		meshexample[26] = { pos = t[9],normal = t[9], u=0, v=0 }
		meshexample[27] = {  pos = t[10], normal = t[10],  u=0, v=0 }

		-- P1, P7, P8
		meshexample[28] = { pos = t[2],normal = t[2], u=0, v=0 }
		meshexample[29] = { pos = t[8], normal = t[8],  u=0, v=0 }
		meshexample[30] = { pos = t[9],normal = t[9], u=0, v=0 }

		-- P7, P6, P8
		meshexample[31] = { pos = t[8], normal = t[8],  u=0, v=0 }
		meshexample[32] = { pos = t[7], normal = t[7],  u=0, v=0 }
		meshexample[33] = { pos = t[9],normal = t[9], u=0, v=0 }

		-- P7, P10, P6
		meshexample[34] = { pos = t[8], normal = t[8],  u=0, v=0 }
		meshexample[35] = { pos = t[11], normal = t[11],  u=0, v=0 }
		meshexample[36] = { pos = t[7], normal = t[7],  u=0, v=0 }

		-- P10, P2, P6
		meshexample[37] = { pos = t[11], normal = t[11],  u=0, v=0 }
		meshexample[38] = { pos = t[3], normal = t[3], u=0, v=0  }
		meshexample[39] = { pos = t[7], normal = t[7],  u=0, v=0 }

		-- P10, P11, P2
		meshexample[40] = { pos = t[11], normal = t[11],  u=0, v=0 }
		meshexample[41] = { pos = t[12], normal = t[12],  u=0, v=0 }
		meshexample[42] = { pos = t[3], normal = t[3], u=0, v=0  }

		-- P11, P4, P2
		meshexample[43] = { pos = t[12], normal = t[12],  u=0, v=0 }
		meshexample[44] = { pos = t[5], normal = t[5],  u=0, v=0 }
		meshexample[45] = { pos = t[3], normal = t[3], u=0, v=0 }

		-- END OF CENTRAL STRIP

		-- BEGIN LOWER 5

		-- P3, P4, P9
		meshexample[46] = { pos = t[4], normal = t[4],  u=0, v=0 }
		meshexample[47] = { pos = t[5], normal = t[5],  u=0, v=0 }
		meshexample[48] = { pos = t[10], normal = t[10],  u=0, v=0 }

		-- P3, P9, P8
		meshexample[49] = { pos = t[4], normal = t[10],  u=0, v=0 }
		meshexample[50] = { pos = t[10], normal = t[10],  u=0, v=0 }
		meshexample[51] = { pos = t[9], normal = t[9],  u=0, v=0 }

		-- P3, P8, P6
		meshexample[52] = { pos = t[4], normal = t[4],  u=0, v=0 }
		meshexample[53] = { pos = t[9], normal = t[9],  u=0, v=0 }
		meshexample[54] = { pos = t[7], normal = t[7],  u=0, v=0 }

		-- P3, P6, P2
		meshexample[55] = { pos = t[4], normal = t[4],  u=0, v=0 }
		meshexample[56] = { pos = t[7], normal = t[7],  u=0, v=0 }
		meshexample[57] = { pos = t[3], normal = t[3],  u=0, v=0 }

		-- P3, P2, P4
		meshexample[58] = { pos = t[4], normal = t[4],  u=0, v=0 }
		meshexample[59] = { pos = t[3], normal = t[3],  u=0, v=0 }
		meshexample[60] = { pos = t[5], normal = t[5],  u=0, v=0 }


		-- normal is where the light source is located, think of this as positioning the sun
		-- u is the horizontal texture cord , v is the vertical, they are floats
		-- u = 0 , v = 0 would be the bottom left of the texture , 0,1 is top left

		self.mesh:BuildFromTriangles( meshexample )--GM.class.getClass("Icosahedron"):new() )
	end

end

if SERVER then

	function ENT:StartTouch( ent )
		--Add player to the environment
		self:getCelestial():getEnvironment():addEntity( ent )
		print("Begin Touch", self)
	end

	function ENT:EndTouch( ent )
		--Remove player from the environment
		self:getCelestial():getEnvironment():removeEntity( ent )
		print("End Touch", self)
	end

	function ENT:Think()
		self:getCelestial():Think()
	end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()

		local scale = 3200

		local mat = Matrix()
		mat:Translate( self:GetPos() )
		--mat:Rotate(Angle(0,0,-15))
		mat:Scale( Vector( 1, 1, 1 ) * scale )


		render.SetMaterial( Material("editor/wireframe") )
		cam.PushModelMatrix ( mat )
			self.mesh:Draw()
		cam.PopModelMatrix()
	end

	--[[local function test()
	    local t = {}

		t[1] = {
			pos = Vector(0,0,1),
			u = 1,
			v = 0,
			normal = Vector(0,0,1):GetNormalized()
		}
		t[2] = {
			pos = Vector(0,1,0),
			u = 1,
			v = 0,
			normal = Vector(0,1,0):GetNormalized()
		}
		t[3] = {
			pos = Vector(1,0,0),
			u = 1,
			v = 0,
			normal = Vector(1,0,0):GetNormalized()
		}

		return t

	end

	local Obj = Mesh()
	Obj:BuildFromTriangles( test() )
	--Obj:SetPos( ENT:GetPos() )
	Obj:Draw()

	hook.Add( "PostDrawOpaqueRenderables", "IMeshTest", function( self )
		local mat = Material( "editor/wireframe ")
		render.SetMaterial( mat ) -- Apply the material
		Obj:Draw() -- Draw the mesh
	end ) ]]
end

function ENT:CanTool()
	return false -- So the ent cannot be tooled ( parent, rope etc )
end

function ENT:GravGunPunt()
	return false -- So the player can't move the planet
end

function ENT:GravGunPickupAllowed()
	return false -- So the player can't pick the planet up and run off with it.
end
