local GM = GM

local C = GM.LCS.class({
	radius = 1,
	subdivision = 0,
	vertices = {},
	faces = {},
	phi = (1 + math.sqrt(5))/2
})

local function genVertices( self )
	local p = self:getPhi()

	self:addVertices( Vector(-1, p, 0) )
	self:addVertices( Vector(1, p, 0) )
	self:addVertices( Vector(-1, -p, 0) )
	self:addVertices( Vector(1, -p, 0) )

	self:addVertices( Vector(0, -1, p) )
	self:addVertices( Vector(0, 1, p) )
	self:addVertices( Vector(0, -1, -p) )
	self:addVertices( Vector(0, 1, -p) )

	self:addVertices( Vector(p, 0, -1) )
	self:addVertices( Vector(p, 0, 1) )
	self:addVertices( Vector(-p, 0, -1) )
	self:addVertices( Vector(-p, 0, 1) )

	return self:getVertices()
end

local function genTri(p1,p2,p3)
	return { {
		pos = p1,
		u = 0,
		v = 0,
		normal = p1
	},{
		pos = p2,
		u = 0,
		v = 0,
		normal = p2
	},{
		pos = p3,
		u = 0,
		v = 0,
		normal = p3
	} }
end

local function addT(...)
	local tbl = {...}
	local t = {}

	for i=1, #tbl do
		for j=1, #tbl[i] do
			t[#t + 1] = tbl[i][j]
		end
	end

	return t
end

local function genFaces( self)

	local v = self:getVertices()

	return addT( genTri( v[1], v[6], v[12] ), genTri( v[1],v[12],v[11] ) )--, genTri( v[1], v[11], v[8] ), genTri( v[1], v[8], v[2] ) )
end

function C:init(r, s)
	self:setRadius( r or self:getRadius() )
	self:setSubDivision( s or self:getSubDivision() )

	-- Generate Icosahedron
	genVertices( self )

	return genFaces( self )

	-- Refine Icosahedron
end

function C:getRadius()
	return self.radius
end

function C:setRadius( r )
	if type(r) ~= "number" then error("Expected number, got "..type(r)) return end
	self.radius = 1
end

function C:getSubDivision()
	return self.subdivision
end

function C:setSubDivision( s )
    if type(s) ~= "number" then error("Expected number, got "..type(s)) return end
	self.subdivision = s
end

function C:getVertices()
	return self.vertices
end

function C:addVertices( v )
	self:getVertices()[#self:getVertices() + 1] = v
end

function C:getPhi()
	return self.phi
end

function C:getFaces()
	return self.faces
end

function C:addFace( f )
	if type(f) ~= "table" then error("Expected table, got "..type(f)) return end
end



GM.class.registerClass("Icosahedron", C)