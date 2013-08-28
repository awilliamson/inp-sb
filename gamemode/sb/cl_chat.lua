local ChatVGUI = nil
local ChosenChatLevel = "ALL"
local NumberOfBodies = 0
local HtmlTemplate = [[
<html>
	<head>
		<style type="text/css">
			#messages {
				padding: 5px;
				width: 95%;
				padding-bottom: 0px;
				display:break-word;
			}
			.message {
				padding: 1px;
			}
			.username 
			{
				text-decoration: none;
			}
			html
			{
				margin-top: 0px;
				color:white;
				font-family:'Verdana';
				font-size:14px;
				padding-bottom:0px;
				font-weight:700;
				text-decoration: none;
				overflow: hidden;
			}
			div
			{
				display:break-word;
			}
		</style>
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	</head>
		<body>
		<div id="messages"></div>
		
		<script type="text/javascript">
			function handleMessage(message)
			{
				var isAtBottom=((window.innerHeight+window.scrollY)>=document.body.offsetHeight);
				var messParts=message.split("</span>");
				var add=messParts[0]+"</span>";
				messParts.splice(0,1);
				add+=messParts.join("");
				var messageElem=document.createElement('div');
				messageElem.className="message";
				messageElem.innerHTML=add;
				var messagesContainer=document.getElementById("messages");
				messagesContainer.appendChild(messageElem);
				$(messageElem).animate({ opacity: 0 }, 20000);
				if(isAtBottom){document.body.scrollTop=document.body.scrollHeight}
			}
		</script>
	</body>
</html>
]]

local function AddChatBody(name)
	local cx, cy = ChatVGUI:GetPos()
	local body = vgui.Create( "DHTML" )
	
	body:SetHTML(HtmlTemplate)
	body.html = HtmlTemplate
	
	body:SetPos( cx + 5, cy + 18 )
	body:SetSize( ScrW() * .5 - 5, 182+(ScrH()*0.05) )
	body:SetVisible( false )

	ChatVGUI.Bodies[name] = body
	
	local OptBut = vgui.Create( "DColorButton", ChatVGUI )
	OptBut:SetPos( 8+(32*NumberOfBodies), 2 )
	OptBut:SetSize( 30, 15 )
	OptBut:SetColor( Color( 90, 90, 90, 255 ) )
	OptBut:SetText( name )
	OptBut.LastFlash = 0
	OptBut.IsFlashed = false
	OptBut.ShouldFlash = false
	OptBut.Nam = name
	OptBut.DoClick = function( pnl )
		pnl:SetColor( Color( 60, 60, 60, 255 ) )
		
		pnl.ShouldFlash = false
		
		pnl:SetColor( Color( 90, 90, 90, 255 ) )
		
		for i,k in pairs(ChatVGUI.Bodies) do
			k:SetVisible(false)
		end
		
		ChosenChatLevel = OptBut.Nam
		
		ChatVGUI.Bodies[pnl.Nam]:SetVisible( true )
		ChatVGUI.Bodies[pnl.Nam]:SetZPos( 1000 )
	end
	
	ChatVGUI.Bodies[name].OptBut = OptBut
	NumberOfBodies = NumberOfBodies + 1
	
	return ChatVGUI.Bodies[name]
end

local function CreateChatGUI()
	ChatVGUI = vgui.Create( "DPanel" )
	ChatVGUI:SetPos( 40, ScrH() - 335 - (ScrH()*0.05) )
	ChatVGUI:SetSize( ScrW() * .5, 200+(ScrH()*0.05) )
	ChatVGUI:SetBackgroundColor( Color( 70, 70, 70, 110 ) )
	ChatVGUI:SetVisible( false )
	ChatVGUI.Bodies = {}

	local cx, cy = ChatVGUI:GetPos()
	
	AddChatBody("ALL")
	AddChatBody("TEAM")
	
	ChatVGUI.Bodies["ALL"]:SetVisible(true)
	
	ChatVGUI.CloseLink = vgui.Create( "DButton", ChatVGUI )
	ChatVGUI.CloseLink:SetPos( ScrW() * .5 - 15, 2 )
	ChatVGUI.CloseLink:SetText( "X" )
	ChatVGUI.CloseLink:SetSize(15,15)
	ChatVGUI.CloseLink:SetVisible( true )
	ChatVGUI.CloseLink.DoClick = function() ChatVGUI:SetVisible( false ) gui.EnableScreenClicker( false ) end
	
	local tx, ty = ChatVGUI:GetPos()
	ChatVGUI.ChatTextEntry = vgui.Create( "DTextEntry", ChatVGUI )
	ChatVGUI.ChatTextEntry:SetPos( tx + 5, ty + 200 + (ScrH()*0.05) )
	ChatVGUI.ChatTextEntry:SetSize( ScrW() * .5 - 15, 15 )
	ChatVGUI.ChatTextEntry:SetVisible( true )
	ChatVGUI.ChatTextEntry:SetEnabled( true )
	ChatVGUI.ChatTextEntry:SetKeyboardInputEnabled( true )
	ChatVGUI.ChatTextEntry:SetMouseInputEnabled( true )
	ChatVGUI.ChatTextEntry.OnEnter = function()
		if(ChatVGUI.ChatTextEntry) then
			if( string.gsub( ChatVGUI.ChatTextEntry:GetValue(), " ", "" ) ~= "" ) then
				net.Start("PlayerSay")
				net.WriteString(ChatVGUI.ChatTextEntry:GetValue())
				net.WriteBit(ChatVGUI.ChatTextEntry.IsTeam)
				net.SendToServer()
			end
			
			ChatVGUI.Bodies[ChosenChatLevel]:QueueJavascript([[document.documentElement.style.overflow = 'hidden';
															$(".message").stop(true, true);
															$(".message").animate({ opacity: 0 }, 10000);]])
			ChatVGUI.ChatTextEntry:SetText( "" )
			ChatVGUI:SetVisible( false )
			
			gui.EnableScreenClicker( false )
			hook.Run("FinishChat")
		end
	end
end
hook.Add("InitPostEntity", "LoadChat", CreateChatGUI)

function GM:HUDShouldDraw(name)
	if(name == "CHudChat") then  -- Stop default HUD behaviour ALL OF IT
		return false
	end
	return true -- Otherwise all the hud elements go bye bye :C
end

local function msgCreateChatVGUI(isTeam)
	if not ChatVGUI then CreateChatGUI() end
	
	ChatVGUI:SetVisible(true)
	ChatVGUI.Bodies[ChosenChatLevel]:QueueJavascript([[document.documentElement.style.overflow = 'auto';
													$(".message").stop(true, true);
													$(".message").animate({ opacity: 1 }, 200);]])
	ChatVGUI.ChatTextEntry.IsTeam = isTeam or false
	ChatVGUI.ChatTextEntry:MakePopup()
	
	gui.EnableScreenClicker( true )
end

local function OpenChat(ply, bind, pressed)
    if (ply == LocalPlayer()) then
        if (bind == "messagemode" or bind == "messagemode2") and pressed then -- messagemode, they're opening chat 
			local isTeam = false
		
			if bind == "messagemode2" then
				isTeam = true
			end
			
            if not hook.Run("StartChat", isTeam) then 
				msgCreateChatVGUI(isTeam)
			end 

            return true
        end
    end
end
hook.Add("PlayerBindPress","ChatBind",OpenChat) -- Check binds

local oldaddtext = chat.AddText
function chat.AddText2(tab, ...)
	--Sometimes this hasn't loaded yet when we want to put things into the chatbox, so lets give it a chance to load.
	if not IsValid(ChatVGUI) then
		local varargs = {...}
		timer.Simple(1, function()
			--Bleh have to unpack this because it dislikes being used outside of the function its used in originally.
			chat.AddText2(tab, unpack(varargs))
		end)
		return
	end
	
	local body = ChatVGUI.Bodies[tab]
	local insert = ""
	
	local colorChangeCount = 0
	
	for i,k in pairs({...}) do
		local typ = string.lower(tostring(type(k)))
		if typ == "player" then
			local col = player_manager.RunClass( k, "getRaceColor" )

			local rankColor = "rgba(".. col.r ..",".. col.g ..",".. col.b ..",".. col.a ..")"
			
			insert = insert .. [[<span class="username" style="color:]]..rankColor..[[">]] .. (k:Nick()) .. [[</span>]]
		elseif typ == "table" then
			if k.r and k.g and k.b then
				local color = "rgba(".. k.r ..",".. k.g ..",".. k.b ..",".. k.a ..")"
				if colorChangeCount > 0 then insert = insert .. [[</span>]] end
				insert = insert .. [[<span class="username" style="color:]]..color..[[">]]
				
				colorChangeCount = colorChangeCount + 1
			end
		else
			local strToInsert = tostring(k)
			
			strToInsert = string.gsub(string.gsub(strToInsert,"<","&lt"),">","&gt")
			strToInsert = string.gsub(strToInsert, "\\n", "<br />")
			
			insert = insert .. strToInsert
		end
	end
	
	if colorChangeCount > 0 then insert = insert .. [[</span>]] end
	
	if insert != "" and body != nil then 
		insert = string.gsub(insert, "\"", "\\\"")
		insert = string.gsub(insert, "\'", "\\'") 
		insert = string.gsub(insert, ":","\\:") 
		insert = string.gsub(insert, "/", "\\/")

		body:QueueJavascript([[handleMessage("]]..insert..[[")]])
	end
	
	oldaddtext(...)
end

function chat.AddText(...)
	chat.AddText2("ALL", ...)
end

net.Receive( "AddToChatBox", function()
	if( not ChatVGUI ) then return end
	
	local tab = net.ReadString()
	local data = net.ReadTable()
	
	chat.AddText2(tab, unpack(data))
	
	if ChosenChatLevel == "ALL" and tab ~= "ALL" then chat.AddText2("ALL", unpack(data)) end
		
	if( tab ~= ChosenChatLevel and ChosenChatLevel ~= "ALL" ) then
		ChatVGUI.Bodies[tab].OptBut.ShouldFlash = true
	end
end)

local function ChatBoxThink()
	if( ChatVGUI and ChatVGUI:IsVisible() ) then
		for k,n in pairs(ChatVGUI.Bodies) do
			if( n.OptBut.ShouldFlash ) then
				if( CurTime() - n.OptBut.LastFlash > .4 ) then
					local color = Color( 60, 60, 60, 255 )
					
					if( not n.OptBut.IsFlashed ) then
						color = Color( 30, 30, 190, 255 )
						n.OptBut.IsFlashed = true
					else
						n.OptBut.IsFlashed = false
					end
					
					n.OptBut:SetColor( color )
					
					n.OptBut.LastFlash = CurTime()
				end
			end
		end
	end
end
timer.Create("ChatBoxThink", 1, 0, ChatBoxThink)