hook.Add( "Initialize", "start", function()
	LocalPlayer().selecting = 1
	LocalPlayer().selStart = Vector(0,0,0)
	LocalPlayer().selEnd = Vector(0,0,0)
	LocalPlayer().toolCost = -1
	LocalPlayer().hudColor = Color(10,10,10,20)
	
	LocalPlayer().hover = 0
	LocalPlayer().menu = 0
	LocalPlayer().selectTimer = 0
	LocalPlayer().spawnTimer = 0
	LocalPlayer().cooldown = 0
	LocalPlayer().frame = nil
	
	LocalPlayer().units = 0
	LocalPlayer().credits = 0

	--net.Start("RequestServerTeams")
	--net.SendToServer()
	
	foundMelons = {}

	return true 
end)

team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(255,50,255,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}

hook.Add( "Think", "update", function()	
	if (selecting) then
		LocalPlayer().selEnd = LocalPlayer():GetEyeTrace().HitPos
	end

	local tr = LocalPlayer():GetEyeTrace()
	local ent = tr.Entity
	if (ent:GetNWString("message", "nope") != "nope") then
        AddWorldTip( nil,ent:GetNWString("message", "nope"), nil, Vector(0,0,0), ent )
    end
end)

net.Receive( "Selection", function( len, pl )
	if (LocalPlayer():KeyDown(IN_SPEED)) then
		else table.Empty(foundMelons) end
	local ammount = net.ReadInt(16)
	for i = 1,ammount do
        table.insert(foundMelons, net.ReadEntity())
    end
	LocalPlayer():SetNWVector("selEnd", LocalPlayer():GetNWVector("selStart", Vector(0,0,0)))
	LocalPlayer().selEnd = Vector(0,0,0)
end )

net.Receive( "RestartQueue", function( len, pl )
	LocalPlayer().spawntime = CurTime()
end)
--[[
net.Receive( "SendContraption", function( len, pl )
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 160
	local cost = net.ReadInt(32)
	local cons = net.ReadInt(32)
	local freeze = net.ReadBool()
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Contraption Legalizer")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	if (cost != -1) then
		local label = vgui.Create("DLabel", frame)
		label:SetSize(200,30)
		label:SetPos(20,40)
		label:SetText("The contraption will cost "..cost)
		if (cons > 0) then
			label = vgui.Create("DLabel", frame)
			label:SetSize(200,60)
			label:SetPos(20,50)
			label:SetText("Entities like thrusters, hoverballs, vehicles\n and alike will get removed. "..cons.." detected!")
		end
	else
		local label = vgui.Create("DLabel", frame)
		label:SetSize(200,30)
		label:SetPos(20,40)
		label:SetText("No contraption found")
	end

	if (freeze) then
		label = vgui.Create("DLabel", frame)
		label:SetSize(100,40)
		label:SetPos(20,100)
		label:SetText("Can't legalize.\nContraption is frozen.")
	elseif (cons == -1) then
		button = vgui.Create("DButton", frame)
		button:SetSize(100,40)
		button:SetPos(20,100)
		button:SetText("Load")
		function button:DoClick()
			net.Start("ContraptionLoad")
				--net.WriteInt(cvars.Number("mw_team"),8)
			net.SendToServer()
			frame:Remove()
			frame = nil
		end
	else
		button = vgui.Create("DButton", frame)
		button:SetSize(100,40)
		button:SetPos(20,100)
		button:SetText("Save")
		function button:DoClick()
			ContraptionSave(LocalPlayer():GetEyeTrace().Entity)
			--net.Start("ContraptionSave")
			--	net.WriteEntity(LocalPlayer():GetEyeTrace().Entity)
			--net.SendToServer()
			frame:Remove()
			frame = nil
		end
	end

	button = vgui.Create("DButton", frame)
	button:SetSize(100,40)
	button:SetPos(130,100)
	button:SetText("Cancel")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
end )]]

net.Receive("ContraptionSaveClient", function (len, pl)
	local dubJSON = net.ReadString()
	local name = net.ReadString()
	file.CreateDir( "melonwars/contraptions" )
	file.Write( "melonwars/contraptions/"..name..".txt", dubJSON )
end)

hook.Add("OnTextEntryGetFocus", "disableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = true
end)

hook.Add("OnTextEntryLoseFocus", "enableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = false
end)

hook.Add( "OnContextMenuOpen", "AddHalos", function()
	LocalPlayer():ConCommand("mw_context_menu 1")
end )

hook.Add( "OnContextMenuClose", "AddHalos", function()
	LocalPlayer():ConCommand("mw_context_menu 0")
end )

hook.Add( "PreDrawHalos", "AddHalos", function()

	if (istable(foundMelons)) then
		halo.Add( foundMelons, Color( 255, 255, 100 ), 2, 2, 1, true, true )
	end

	local entityTable = {}
	if (LocalPlayer():KeyDown(IN_WALK)) then
		table.Empty(entityTable)
		local eyeEntity = LocalPlayer():GetEyeTrace().Entity
		if (tostring( eyeEntity ~= "Entity [0][worldspawn]")) then
			table.insert(entityTable, eyeEntity)
		if (istable(entityTable)) then
				halo.Add( entityTable, Color( 255, 100, 100 ), 2, 2, 1, true, true )
			end
		end
	end

	local zoneTable = ents.FindByClass( "ent_melon_zone" )
	local a = LocalPlayer():GetInfoNum("mw_team", 0)

	for i = table.Count(zoneTable), 1, -1 do
		if (zoneTable[i]:GetNWInt("zoneTeam", 0) != a or (zoneTable[i]:GetPos()-LocalPlayer():GetPos()):LengthSqr() > 10000000) then
			table.remove(zoneTable, i)
		end
	end
	halo.Add( zoneTable, Color(200,200,200,255), 0, 3, 1, true, true )
end)

Laser = Material( "vgui/wave.png", "noclamp smooth" )
hook.Add( "PostDrawTranslucentRenderables", "hud", function()
	--local trace = LocalPlayer():GetEyeTrace()
	local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
	--render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color( 255, 0, 0 ), true )
	--render.DrawLine( trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color( 0, 255, 0 ), true )
	--render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Up(), Color( 0, 0, 255 ), true )
	if (istable(foundMelons)) then
		
		render.SetMaterial( Laser )
		for k, v in pairs( foundMelons ) do
			if (IsValid(v)) then
				local hp = v:GetNWFloat("health", 0)
				local maxhp = v:GetNWFloat("maxhealth", 1)
				local vpos = v:WorldSpaceCenter()+Vector(0,0,10)+angle:Forward()*20-angle:Right()*hp/2
				cam.Start3D2D( vpos, angle, 1 )
					surface.SetDrawColor( Color( 255*math.min((1-hp/maxhp)*2,1), 255*math.min(hp/maxhp*2,1), 0, 255 ) )
					surface.DrawRect( 0, 0, 5, hp )
					surface.SetDrawColor( Color( 0,0,0, 255 ) )
					surface.DrawOutlinedRect( 0, 0, 5, hp )
				cam.End3D2D()
				if (v:GetNWBool("moving", false)) then
					render.DrawBeam( v:WorldSpaceCenter(), v:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
				end
				if (v:GetNWEntity("targetEntity", nil):IsValid() && v:GetNWEntity("targetEntity", nil) != nil) then
					render.DrawBeam( v:WorldSpaceCenter(), v:GetNWEntity("targetEntity"):WorldSpaceCenter(), 1, 1, 1, Color( 255, 0, 0, 100 ) )
				end
				if (v:GetNWEntity("followEntity", nil):IsValid()) then
					render.DrawBeam( v:WorldSpaceCenter(), v:GetNWEntity("followEntity"):WorldSpaceCenter(), 1, 1, 1, Color( 0, 50, 255, 100 ) )
				end
			end
		end
	end
	
	if (LocalPlayer().selecting and LocalPlayer():GetNWVector("selStart", Vector(0,0,0)) ~= Vector(0,0,0)) then
		local selStart = LocalPlayer():GetNWVector("selStart", Vector(0,0,0))
		local selEnd = LocalPlayer():GetNWVector("selEnd", Vector(0,0,0))
		local radius = selStart:Distance(selEnd)/2
		surface.SetDrawColor(Color( 0, 255, 0, 255 ))
		cam.Start3D2D((selStart+selEnd)/2 + Vector(0,0,3), Angle(0,0,0), 3 )
		for i = 1, 160 do
			surface.DrawRect( math.sin(i/math.pi/8)*radius/3, math.cos(i/math.pi/8)*radius/3, 2, 2)
		end
		cam.End3D2D()
	end
	--surface.DrawRect( 0, 0, 8, 8 )
	--render.DrawLine( Vector( 0, 0, 0 ), Vector( 8, 8, 8 ), Color( 100, 149, 237, 255 ), true )
	
	local points = ents.FindByClass( "ent_melon_cap_point" )
	table.Add(points, ents.FindByClass( "ent_melon_outpost_point" ))
	table.Add(points, ents.FindByClass( "ent_melon_mcguffin" ))
	table.Add(points, ents.FindByClass( "ent_melon_water_tank" ))
	if (istable(points)) then
		render.SetMaterial( Laser )
		for k, v in RandomPairs( points ) do
			if (IsValid(v)) then
				local captured = {0,0,0,0,0,0,0,0}
				local capturing = 0
				for i=1, 8 do
					if (v:GetNWInt("captured"..tostring(i), 0) > 0) then
						local vpos = v:WorldSpaceCenter()+Vector(0,0,100)+angle:Forward()*10-angle:Right()*5/2
						cam.Start3D2D( vpos, angle, 1 )
							surface.SetDrawColor( team_colors[i] )
							surface.DrawRect( 0, 0, v:GetNWInt("captured"..tostring(i), 0)/2, 5 )
							surface.SetDrawColor( Color( 0,0,0, 255 ) )
							surface.DrawOutlinedRect( 0, 0, 50, 5 )
						cam.End3D2D()
					end
				end
			end
		end
	end
end )

hook.Add( "HUDPaint", "hud", function()

	local AlertIcons = ents.FindByClass( "ent_melon_HUD_alert" )
	local a = LocalPlayer():GetInfoNum("mw_team", 0)
	for k, v in pairs(AlertIcons) do
		if (v:GetNWInt("drawTeam", 0) == a) then
			local pos = v:GetPos():ToScreen()
			pos = Vector(pos.x, pos.y)
			local border = ScrH()/3
			local center = Vector(ScrW()/2, ScrH()/2)
			if ((pos-center):LengthSqr() > border*border) then
				pos = center+(pos-center):GetNormalized()*border
			end
			surface.SetDrawColor(Color(255,0,0,255))
		  	surface.DrawRect( pos.x - 16, pos.y - 20, 32, 40 )
			surface.SetDrawColor(Color(150,0,0,255))
		  	surface.DrawRect( pos.x - 12, pos.y - 16, 24, 32 )
		  	surface.SetDrawColor(Color(255,0,0,255))
		  	surface.DrawRect( pos.x - 3, pos.y - 12, 6, 14 )
		  	surface.DrawRect( pos.x - 3, pos.y + 6, 6, 6 )
		  end
	end
end )

net.Receive( "TeamCredits", function( len, pl )
	LocalPlayer().credits = net.ReadInt(16)
end )

net.Receive( "TeamUnits", function( len, pl )
	LocalPlayer().units = net.ReadInt(16)
end )

net.Receive( "ChatTimer", function( len, pl )
	LocalPlayer().chatTimer = 1000
end )

net.Receive( "RequestContraptionLoadToClient", function( len, pl )
	local _file = net.ReadString()
	local ent = net.ReadEntity()
	net.Start("ContraptionLoad")
		net.WriteString(file.Read( _file ))
		net.WriteEntity(ent)
	net.SendToServer()
end )

net.Receive( "EditorSetTeam", function( len, pl )
	local ent = net.ReadEntity()
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 160
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set team")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	for i=1, 8 do
		button = vgui.Create("DButton", frame)
		button:SetSize(29,100)
		button:SetPos(5+30*(i-1),50)
		button:SetText("")
		function button:DoClick()
			net.Start("ServerSetTeam")
				net.WriteEntity(ent)
				net.WriteInt(i, 4)
			net.SendToServer()
			ent:SetColor(team_colors[i])
			ent.melonTeam = i
			frame:Remove()
			frame = nil
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(30,30,30,255) )
			draw.RoundedBox( 4, 2, 2, w-4, h-4, team_colors[i] )
		end
	end
end )

net.Receive( "EditorSetStage", function( len, pl )
	local ent = net.ReadEntity()
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 100
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set Stage")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	local wang = vgui.Create("DNumberWang", frame)
	wang:SetPos(20,50)
	button = vgui.Create("DButton", frame)
	button:SetSize(100,50)
	button:SetPos(120,35)
	button:SetText("Done")
	function button:DoClick()
		net.Start("ServerSetStage")
			net.WriteEntity(ent)
			net.WriteInt(wang:GetValue(), 8)
		net.SendToServer()
		ent.stage = wang:GetValue()
		frame:Remove()
		frame = nil
	end
end )

net.Receive( "DrawWireframeBox", function( len, pl )
	local pos = net.ReadVector()
	local min = net.ReadVector()
	local max = net.ReadVector()
	render.DrawWireframeBox( pos, Angle(0,0,0), min, max, Color(255,255,255,255), false )
end )	

net.Receive( "EditorSetWaypoint", function( len, pl )
	local ent = net.ReadEntity()
	local waypoint = net.ReadInt(4)
	local path = net.ReadInt(4)
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 110
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set Waypoint")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	local label = vgui.Create("DLabel", frame)
	label:SetPos(20,20)
	label:SetText("Waypoint")
	local waypointwang = vgui.Create("DNumberWang", frame)
	waypointwang:SetPos(20,35)
	if (ent.waypoint == nil) then ent.waypoint = 1 end
	waypointwang:SetValue(ent.waypoint)
	label = vgui.Create("DLabel", frame)
	label:SetPos(20,55)
	label:SetText("Path")
	local pathwang = vgui.Create("DNumberWang", frame)
	pathwang:SetPos(20,70)
	if (ent.path == nil) then ent.path = 1 end
	pathwang:SetValue(ent.path)
	button = vgui.Create("DButton", frame)
	button:SetSize(100,50)
	button:SetPos(120,35)
	button:SetText("Done")
	function button:DoClick()
		net.Start("ServerSetWaypoint")
			net.WriteEntity(ent)
			net.WriteInt(waypointwang:GetValue(), 8)
			net.WriteInt(pathwang:GetValue(), 8)
		net.SendToServer()
		ent.waypoint = waypointwang:GetValue()
		ent.path = pathwang:GetValue()
		frame:Remove()
		frame = nil
	end
end )

--[[net.Receive( "EditorSetSpawnpoint", function( len, pl )
	local ent = net.ReadEntity()
	local waypoint = net.ReadInt(4)
	local path = net.ReadInt(4)
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 110
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set Spawnpoint")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	local label = vgui.Create("DLabel", frame)
	label:SetPos(20,40)
	label:SetText("Spawnpoint")
	local spawnpointwang = vgui.Create("DNumberWang", frame)
	spawnpointwang:SetPos(20,55)
	if (ent.spawnpoint == nil) then ent.spawnpoint = 1 end
	spawnpointwang:SetValue(ent.spawnpoint)
	button = vgui.Create("DButton", frame)
	button:SetSize(100,50)
	button:SetPos(120,35)
	button:SetText("Done")
	function button:DoClick()
		net.Start("ServerSetWaypoint")
			net.WriteEntity(ent)
			net.WriteInt(spawnpointwang:GetValue(), 8)
		net.SendToServer()
		ent.spawnpoint = spawnpointwang:GetValue()
		frame:Remove()
		frame = nil
	end
end )]]


--function TeamUpdate ( newTeam )
	
--end

--net.Receive( "TeamUpdate", function ( len, pl )
	--print("Calling team update")
	--local newTeam = net.ReadInt(4)
	--TeamUpdate ( melonTeam )
	
	--print("Executing team update")
	--LocalPlayer().playerTeam = LocalPlayer():GetInfoNum("mw_team", 1)
	--local newColor = Color(100,100,100,255)
	--if (newTeam == 1) then
	--	newColor = Color(255,50,50,255)
	--end
	--if (newTeam == 2) then
	--	newColor = Color(50,50,255,255)
	--end
	--if (newTeam == 3) then
	--	newColor = Color(255,255,50,255)
	--end
	--if (newTeam == 4) then
	--	newColor = Color(30,200,30,255)
	---end
	--if (newTeam == 5) then
	--	newColor = Color(255,50,255,255)
	--end
	--if (newTeam == 6) then
	--	newColor = Color(50,255,255,255)
	--end
	--print(LocalPlayer())
	--print(LocalPlayer().hudColor)
	--LocalPlayer().hudColor = newColor
	--print("Updated color, maybe")
	--print(LocalPlayer().hudColor)
--end )

--hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
--
--	if (cvars.Number("mw_hud_enable") == 1) then
--
--		if (LocalPlayer().playerTeam == nil) then
--			LocalPlayer().playerTeam = 1
--		end	
--		if (LocalPlayer().hudColor == nil) then
--			LocalPlayer().hudColor = Color(100,100,100,255)
--		end	
--
--		local x = 250
--		local y = 150
--		
--		draw.RoundedBox( 30, ScrW()/2-x/2, ScrH()-y, x, y, LocalPlayer().hudColor )
--		draw.RoundedBox( 15, ScrW()/2-x/2+15, ScrH()-y+15, x-30, y-30, Color(0,0,0,230) )
--		surface.SetFont( "DermaLarge" )
--		surface.SetTextColor( 255, 255, 255, 255 )
--		surface.SetTextPos( ScrW()/2-x/2+30, ScrH()-y+20 )
--		surface.DrawText( tostring(LocalPlayer().toolName) )
--		surface.SetTextPos( ScrW()/2-x/2+30, ScrH()-y+55 )
--		surface.DrawText( "Cost: "..tostring(LocalPlayer().toolCost) )
--		surface.SetTextPos( ScrW()/2-x/2+30, ScrH()-y+90 )
--		surface.DrawText( "Credits: "..tostring(LocalPlayer().credits) )
--	end
--end )