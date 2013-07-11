-- Copyright (C) 2012-2013 Spacebuild Development Team
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local GM = GM
local color = GM.constants.colors
local surface = surface
local draw = draw

local function getLastColor( data )
	local clr = color.white
	for _, v in pairs( data.msg ) do
		if type(v) == "table" and v.r and v.g and v.b then
			clr = v
		end
	end
	return clr
end

local function wrapString( data, maxwidth ) --- TODO MAKE THIS WORK AND IMPLEMENT IN ADDMSG
	surface.SetFont( "ChatText" )
	local linewidth = 0
	local packedlines = { }
	local linenumber = 1
	table.insert(packedlines, { -- Initial Line
		sender = data.sender,
		race = data.race,
		raceColor = data.raceColor,
		msg = {},
		sendTime = data.sendTime,
		teamMsg = data.teamMsg,
		padd = data.padd or 5
	})
	for k, v in pairs(data.msg) do -- For each part of the message
		if type(v) == "string" then
			local w, h = surface.GetTextSize(v) -- Get it's size
			linewidth = linewidth + w -- Increment our width so far

			if linewidth  >= maxwidth - ( data.padd or 5 ) then -- If we overflow.
				linewidth = 0
				linenumber = linenumber + 1 -- New Line :D
				-- Insert a row into packed Lines
				table.insert(packedlines, {
					sender = data.sender,
					race = data.race,
					raceColor = data.raceColor,
					msg = {getLastColor(packedlines[linenumber-1])}, -- Set the colour for this next bit of text
					sendTime = data.sendTime,
					teamMsg = data.teamMsg,
					padd = data.padd or 5
				})
			end

			-- Populate packed lines with lovely messages
			local tbl = packedlines[linenumber]
			local msg = tbl.msg
			table.insert(msg, v)

		end
		if type(v) == "table" and v.r and v.g and v.b then
			-- Add the color
			local tbl = packedlines[linenumber]
			local msg = tbl.msg
			table.insert(msg, v)
		end
	end
	return packedlines
end

local PANEL = {}

AccessorFunc( PANEL, "Padding", 	"Padding" )
AccessorFunc( PANEL, "pnlCanvas", 	"Canvas" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.pnlCanvas 	= vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )

		self:PerformLayout()
		self:InvalidateParent()

	end

	-- Create the scroll bar
	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar.Paint = function( self ) return false end
	self.VBar.btnUp.Paint = function( self ) return false end
	self.VBar.btnDown.Paint = function( self ) return false end
	self.VBar.btnGrip.Paint = function( self ) return false end
	self.VBar:Dock( RIGHT )

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )

end

--[[---------------------------------------------------------
   Name: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( pnl )

	pnl:SetParent( self:GetCanvas() )

end

function PANEL:OnChildAdded( child )

	self:AddItem( child )

end

--[[---------------------------------------------------------
   Name: SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )

end

--[[---------------------------------------------------------
   Name: GetCanvas
-----------------------------------------------------------]]
function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:InnerWidth()

	return self:GetCanvas():GetWide()

end

--[[---------------------------------------------------------
   Name: Rebuild
-----------------------------------------------------------]]
function PANEL:Rebuild()

	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() ) then

	self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )

	end

end

--[[---------------------------------------------------------
   Name: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )

	return self.VBar:OnMouseWheeled( dlta )

end

--[[---------------------------------------------------------
   Name: OnVScroll
-----------------------------------------------------------]]
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )

end

--[[---------------------------------------------------------
   Name: ScrollToChild
-----------------------------------------------------------]]
function PANEL:ScrollToChild( panel )

	self:PerformLayout()

	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()

	y = y + h * 0.5;
	y = y - self:GetTall() * 0.5;

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 );

end


--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()

	if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:Rebuild()


end

function PANEL:Clear()

	return self.pnlCanvas:Clear()

end



derma.DefineControl( "DScrollPanelNoScrollBar", "", PANEL, "DPanel" )




local MESSAGE = {}
function MESSAGE:new( o )
	-- Msg Format
	--o = {sender = ply, race = ply.race, raceColor = ply.raceColor, msg = msg, sendTime = CurTime(), teamMsg = isTeamMsg }
	o.x, o.y = 0, 0
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function MESSAGE:shouldFade( )
	return CurTime() > self.sendTime + 10
end

function MESSAGE:updateTime()
	self.sendTime = CurTime()
end

function MESSAGE:Parent( vgui )
	self.parent = vgui or nil
end

function MESSAGE:GetParent()
	return self.parent or nil
end

function MESSAGE:Paint(  ) -- Each message will be responsible for drawing itself.
	surface.SetFont( "ChatText" )
	local width = 0

	for _, item in pairs(self.msg) do -- Let's dissect our msg data :D
		local r,g,b,a
		if type(item) == "table" and item.r and item.g and item.b and item.a then -- It's a color
			surface.SetTextColor( Color(item.r, item.g, item.b, item.alpha) )
		elseif type(item) == "string" then -- It's actual text
			local w, h = surface.GetTextSize(item) -- How big is this string going to be?
			surface.SetTextPos( self.padd + width, 0 ) -- Set distance along, and how far down
			surface.DrawText( item )
			width = width + w
		end
	end


	-- Paint the message, this should be called to display the message
end

function MESSAGE:IsTeam( )
	return self.teamMsg
end

local PANEL = {}

surface.SetFont("ChatFont")
local _, h = surface.GetTextSize("0")



function PANEL:Init()
	-- Here we want to initialise our panel, get our lovely dimensions and orientation in the world set.
	-- We also want to make children, isn't that the goal of every VGUI element?

	--[[
	-- The structure of the chat is to have 1 absolute chat Panel. This will be our anchor into the screen world
	-- THE ABSOLUTE CHAT PANEL IS SELF!!!! ALL Members will be children of this
	 - Next comes the fakePanel/invisiblePanel This will essentially be a viewport into our messageBox and input field
	   Inside of this viewport we play our Message box and input field spaced out.
	   The messagebox is a DScrollPanel in which we place panels, these little unit panels will be our messages
	   Messages will contain data:
	   	: self.sender will be for who the message belongs to, usually localPlayer otherwise console
	   	: self.race if sender is player then get their race
	   	: likewise self.raceColor will be there as well
	   	: self.message this will be the message string
	   	: self.sendTime will be the CurTime() when the msg was sent, allows for cool fading effects later :D
	   	: self.teamMsg will be for whether it should be team or not, allows for our playerClass to act as a team-
	   Messages will be constructed and added to the messageBox by calling a constructor
	   After this there will be a spacing
	   Then a standard input text field.
	   MessageBox and input will be outline rects, in draw or surface.
	 ]]

	local superparent = self -- So we can access the superparent of any child from within it's functions
	self.maxLines = 10 -- This refer to max amount shown at any given time.
	self.lineSpacing = h + 3 -- Space by max height and then 3
    print("size of h " ..tostring(self.lineSpacing) )
	self.lineMemory = 100 -- Amount of lines to keep stored, too many and it will seriously lag on draw.
	self.color =  Color(50, 50, 50, 70)
	self.outlineColor = color.white

	self:SetSize(520, (self.maxLines+2) * self.lineSpacing) -- Define our size and position
	self:SetPos( 20, ScrH() * 0.75 - self:GetTall() )
	self:SetVisible( false ) -- Make sure people can't see us initially

	self.width,self.height = self:GetSize()

	self.viewport = self:Add( "EditablePanel" )
	self.viewport:SetSize( self:GetSize() ) -- Same size as parent
	self.viewport:SetPos( 0, 0 )

	self.msgBox = self.viewport:Add( "DScrollPanelNoScrollBar" )
	if self.msgBox.VBar then
		self.msgBox.VBar.Paint = function() return false end
	end
	self.msgBox:SetSize( self.width, self.maxLines * self.lineSpacing)
	self.msgBox:SetPos( 0, 0 ) -- Place at top of viewport
	self.msgBox.color = superparent.color
	self.msgBox.msgs = {}
	self.msgBox.scroll = true
	self.msgBox.Paint = function( self )
		local input = superparent.input
		if input and input:HasFocus() then -- Somebody is typing

			-- In box
			draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), self.color )

			-- Outline
			surface.SetDrawColor(superparent.outlineColor)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())

			if self.scroll and self.msgs and #self.msgs > 0 then
				self:ScrollToChild( self.msgs[#self.msgs] )
			end
			self.scroll = false
		end
	end

	local panelPaint = function( self )
		self.msg:Paint()
	end

	self.msgBox.addMsg = function ( self, msgData )
		-- Check for wrap around, make multiple messages based upon number of lines and add them.
		local wrapped = wrapString( msgData, self:GetWide() )

		for k,v in pairs( wrapped ) do

			local msg = MESSAGE:new( v )
			local panel = vgui.Create("Panel", self)
			panel.Paint = panelPaint
			panel:Dock( TOP )
			panel:SetSize( self:GetWide(), superparent.lineSpacing )
			msg:Parent( panel ) -- Set the msgs parent to panel which will be added
			panel.msg = msg
			self:AddItem( panel )
			self:ScrollToChild( panel )
			table.insert( self.msgs, panel )

		end

		-- Check for wrapping / wrap the string

		-- Check if addition of this line will exceed the boundary condition, scroll to compensate

		-- Check if addition of this line will exceed memory limit, remove to compensate
	end

	self.msgBox.VBar.Paint = nil

	self.input = self.viewport:Add( "DTextEntry" )
	self.input.color = superparent.color
	self.input:SetHistoryEnabled( true )
	self.input:SetSize( self.width, 20)
	local x, y = self:GetPos()
	self.input:SetPos( 0, self.viewport:GetTall() - self.input:GetTall() ) -- Place at bottom of viewport
	self.input:SetAllowNonAsciiCharacters(true)
	self.input:SetTextInset(0, 0)

	self.input.Paint = function ( self )
		-- input body
		surface.SetDrawColor(superparent.color)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

		-- input outline
		surface.SetDrawColor(superparent.outlineColor)
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())

		-- Txt Color, Highlight Color, Cursor color
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	self.input.SetTeam = function ( self, bool )
		self.team = bool
	end
	self.input.IsTeam = function( self )
		return self.team
	end

	self.input.turnOffTyping = function ( self )
		self:SetText("")
		self:SetEditable( false )
		self:SetVisible( false )
		self:GetParent():SetVisible( false )
		self:SetTeam( false ) -- Ensure when we close we're back to default or bad things.
		superparent.msgBox.scroll = true
	end


	local oldOnKey = self.input.OnKeyCodeTyped
	self.input.OnKeyCodeTyped = function( self, key)
		if self:IsEditing() and key == KEY_ESCAPE then
			self:turnOffTyping()
			return
		end
		oldOnKey( self, key ) -- Run the old stuff
	end

	self.input.OnValueChange = function( self, strValue)
		self:AddHistory( strValue )
		local msg = MESSAGE:new( {
			sender = LocalPlayer(),
			race = player_manager.RunClass( LocalPlayer(), "getRace" ),
			raceColor = player_manager.RunClass( LocalPlayer(), "getRaceColor" ),
			msg = strValue,
			sendTime = CurTime(),
			teamMsg = self:IsTeam()
		} )
		self:turnOffTyping()
	end

	self.input.OnLoseFocus = function ( self ) -- Also fixes our amazing console problem :D
	    self:turnOffTyping()
	end

	self.viewport:SizeToChildren( false, true) -- Nice and snug
	self:SizeToChildren(false, true)
end

function PANEL:PerformLayout()
	-- Called when things are invalidated
	-- When this happens all the things go to 0,0

	self:SetSize(520, (self.maxLines+2) * self.lineSpacing) -- Define our size and position
	self:SetPos( 20, ScrH() * 0.75 - self:GetTall() )

	self.viewport:SetParent( self )
	self.viewport:SetSize( self:GetSize() ) -- Same size as parent
	self.viewport:SetPos( self:GetPos() )

	self.msgBox:SetParent( self.viewport )
	self.msgBox:SetSize( self.width, self.maxLines * self.lineSpacing )
	self.msgBox:SetPos( self:GetParent():GetPos() ) -- Place at top of viewport

	self.input:SetParent( self.viewport )
	self.input:SetSize( self.width, 20)
	local x, y = self:GetParent():GetPos()
	self.input:SetPos( 0, self.viewport:GetTall() - self.input:GetTall() ) -- Place at bottom of viewport

	self.viewport:SizeToChildren( false, true) -- Nice and snug
	self:SizeToChildren(false, true)
end

vgui.Register('DChatPanel', PANEL, 'EditablePanel')
MsgN("REGISTERED THE VGUI ELEMENT!")
