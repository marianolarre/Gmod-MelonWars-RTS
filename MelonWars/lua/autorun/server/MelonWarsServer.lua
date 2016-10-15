-- ( Some lines from the cl_spawnmenu.lua in the sandbox GM )
--function GM:Initialize()
--Net vars para mandar el equipo y los creditos al cliente
util.AddNetworkString( "TeamCredits" )
util.AddNetworkString( "TeamUpdate" )
util.AddNetworkString( "TeamUnits" )
util.AddNetworkString( "UpdateClientInfo" )
util.AddNetworkString( "UpdateServerInfo" )

util.AddNetworkString( "SpawnUnit" )
util.AddNetworkString( "SpawnBase" )
--util.AddNetworkString( "SpawnTransport" )
util.AddNetworkString( "SpawnProp" )
util.AddNetworkString( "StartGame" )
util.AddNetworkString( "SandboxMode" )

util.AddNetworkString( "ToggleBarracks" )
util.AddNetworkString( "ActivateGate" )
util.AddNetworkString( "ActivateWaypoints" )

util.AddNetworkString( "DestroyUnitTransport" )
util.AddNetworkString( "PropellerReady" )
util.AddNetworkString( "UseWaterTank" )

util.AddNetworkString( "RestartQueue" )

util.AddNetworkString( "CalcContraption" )

util.AddNetworkString( "UpdateClientTeams" )
util.AddNetworkString( "UpdateServerTeams" )
util.AddNetworkString( "RequestServerTeams" )

util.AddNetworkString( "ContraptionSave" )
util.AddNetworkString( "ContraptionSaveClient" )
util.AddNetworkString( "ContraptionLoad" )
util.AddNetworkString( "RequestContraptionLoadToAssembler" )
util.AddNetworkString( "RequestContraptionLoadToClient" )

util.AddNetworkString( "EditorSetTeam" ) -- Unit marker
util.AddNetworkString( "ServerSetTeam" )
util.AddNetworkString( "EditorSetStage" ) -- Main base marker
util.AddNetworkString( "ServerSetStage" )
util.AddNetworkString( "EditorSetWaypoint" ) -- Waypoint
util.AddNetworkString( "ServerSetWaypoint" )
util.AddNetworkString( "DrawWireframeBox" )
--[[util.AddNetworkString( "EditorSetSpawnpoint" ) -- Waypoint
util.AddNetworkString( "ServerSetSpawnpoint" )]]

util.AddNetworkString( "ChatTimer" )

--CreateConVar( "mw_save_name", "default", 8192, "Set the name of the file to save with 'mw_save'" )
--CreateConVar( "mw_save_name_custom", "default", 8192, "Set the name of the file to save with 'mw_save'" )
CreateConVar ( "mw_save_name", "default", 8192, "Set the name of the file to save with 'mw_save'" )
CreateConVar ( "mw_save_path", "default", 8192, "Set the path of the file to save with 'mw_save'" )

team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(255,50,255,255),Color(100,255,255,255),Color(255,120,0,255),Color(10,30,70,255)}

function AddTabs()
	spawnmenu.AddToolTab( "MelonWars", "#Unique_Name", "icon16/wrench.png" )
end
-- Hook the Tab to the Spawn Menu
hook.Add( "AddToolMenuTabs", "MelonWars", AddTabs )

teamCredits = {2000,2000,2000,2000,2000,2000,2000,2000}
teamUnits = {0,0,0,0,0,0,0,0}
teamUnlocks = {0,0,0,0,0,0,0,0}

teamgrid = {}

-- That way you are overriding the default hook
-- you can use hook.Add to make more functions get called when this event occurs

function ExchangeEnergy (ent)

	local energytotal = 0
	local capacitytotal = 0
	local percentage = 0
	for k, v in pairs(ent.connections) do
		if (v:GetNWBool("canGive", false) and v.spawned) then
			energytotal = energytotal + v:GetNWInt("energy", 0)
			capacitytotal = capacitytotal + v:GetNWInt("maxenergy", 0)
		end
	end
	energytotal = energytotal + ent:GetNWInt("energy", 0)
	capacitytotal = capacitytotal + ent:GetNWInt("maxenergy", 0)
	if (capacitytotal != 0) then
		percentage = energytotal/capacitytotal
		for k, v in pairs(ent.connections) do
			if (v:GetNWBool("canGive", false) and v.spawned) then
				v:SetNWInt("energy", percentage*v:GetNWInt("maxenergy", 0))
			end
		end
		ent:SetNWInt("energy", percentage*ent:GetNWInt("maxenergy", 0))
	end
end

function PullEnergy (ent)
	local energytotal = 0
	local capacitytotal = 0
	local percentage = 0
	for k, v in pairs(ent.connections) do
		if (v:GetNWBool("canGive", false) and v.spawned) then
			energytotal = energytotal + v:GetNWInt("energy", 0)
			capacitytotal = capacitytotal + v:GetNWInt("maxenergy", 0)
		end
	end
	--energytotal = energytotal + ent:GetNWInt("energy", 0)
	--capacitytotal = capacitytotal + ent:GetNWInt("maxenergy", 0)
	if (capacitytotal != 0) then
		local suckedEnergy = math.min(energytotal, ent:GetNWInt("maxenergy", 0) - ent:GetNWInt("energy", 0))
		energytotal = energytotal - suckedEnergy
		percentage = energytotal/capacitytotal
		for k, v in pairs(ent.connections) do
			if (v:GetNWBool("canGive", false) and v.spawned) then
				v:SetNWInt("energy", percentage*v:GetNWInt("maxenergy", 0))
			end
		end
		ent:SetNWInt("energy", ent:GetNWInt("energy", 0)+suckedEnergy)
	end
end

function CalculateConnections(ent)
	timer.Simple(0.05, function ()
		constraint.RemoveConstraints( ent, "Rope" )
		local conammount = 0
		local a = 100
		while (conammount < 5 and a < 700) do
			ent.connections = ents.FindInSphere( ent:GetPos(), a )
			for i = table.Count(ent.connections), 1, -1 do
				if (ent.connections[i] == ent or ent.connections[i]:GetNWInt("energy", -123) == -123 or ent:GetNWInt("melonTeam", -1) != ent.connections[i]:GetNWInt("melonTeam", -1)) then
					table.remove(ent.connections, i)
				end
			end

			for k, v in pairs(ent.connections) do
				if (conammount < 5) then
					conammount = conammount + 1
				end
			end
			a = a+200
		end

		for k, v in pairs(ent.connections) do
			constraint.Rope( ent, v, 0, 0, ent:GetNWVector("energyPos",Vector(0,0,0)), v:GetNWVector("energyPos",Vector(0,0,0)), ent:LocalToWorld( ent:GetNWVector("energyPos",Vector(0,0,0)) ):Distance(v:LocalToWorld( v:GetNWVector("energyPos",Vector(0,0,0)) )), 100, 1, 3, "cable/cable2", false )
			local addcon = {ent}
			table.Add(v.connections, addcon)
		end		
	end)	
end

local function spawn( ply )
	ply.hover = 0
	ply.menu = 0
	ply.selectTimer = 0
	ply.spawnTimer = 0
	ply.frame = nil
	ply.credits = 2000
	for k, v in pairs( player.GetAll() ) do
		net.Start("UpdateClientTeams")
			net.WriteTable(teamgrid)
		net.Send(ply)
	end
	util.PrecacheModel( "models/hunter/tubes/circle2x2.mdl" )
end
hook.Add( "PlayerInitialSpawn", "some_unique_name", spawn )

local function takedmg( target, dmginfo )
	if (dmginfo:GetAttacker():GetClass() ~= "player") then
		if (target.Base == "ent_melon_prop_base") then
			target:SetNWFloat( "health", target:GetNWFloat( "health", 1)-dmginfo:GetDamage())
			if (target:GetNWFloat( "health", 1) <= 0) then
				target:PropDefaultDeathEffect( target )
			end
		elseif (target:GetNWInt("propHP", -1) ~= -1) then
			target:SetNWInt( "propHP", target:GetNWInt( "propHP", 1)-dmginfo:GetDamage())
			if (target:GetNWInt( "propHP", 1) <= 0) then
				local effectdata = EffectData()
				effectdata:SetOrigin( target:GetPos() )
				util.Effect( "Explosion", effectdata )
				target:Remove()
			end
		end
	end
end
hook.Add( "EntityTakeDamage", "entitytakedmg", takedmg )

net.Receive( "ActivateGate", function( len, pl )
	local ent = net.ReadEntity()
	ent:Actuate();
end)

net.Receive( "UpdateClientInfo", function( len, pl )
	local a = net.ReadInt(8)
	if (a != 0) then
		net.Start("TeamCredits")
			net.WriteInt(teamCredits[a] ,16)
		net.Send(pl)
		net.Start("TeamUnits")
			net.WriteInt(teamUnits[a] ,16)
		net.Send(pl)
	else
		net.Start("TeamCredits")
			net.WriteInt(20000 ,16)
		net.Send(pl)
		net.Start("TeamUnits")
			net.WriteInt(0 ,16)
		net.Send(pl)
	end
end )

net.Receive( "UpdateServerInfo", function( len, pl )
	local a = net.ReadInt(8)
	teamCredits[a] = net.ReadInt(16)
	--teamUnits[a] = net.ReadInt(16)
end )

net.Receive( "ToggleBarracks", function( len, pl )
	local ent = net.ReadEntity()
	local on = ent:GetNWBool("active", false)
	if (on) then
		ent:SetNWBool("active", false)
	else
		ent:SetNWBool("active", true)
	end
end )

net.Receive( "DestroyUnitTransport", function( len, pl )
	local ent = net.ReadEntity()
	ent:FreeUnits()
end )

net.Receive( "PropellerReady", function( len, pl )
	local ent = net.ReadEntity()
	ent:SetNWBool("done",true)
	local foundEnts = ents.FindInSphere(ent:GetPos(), 600 )
	for k, v in pairs( foundEnts ) do
		if (v:GetClass() == "ent_melon_propeller" or v:GetClass() == "ent_melon_hover") then
			v:SetNWBool("done",true)
		end
	end
end )

net.Receive( "UseWaterTank", function( len, pl )
	local ent = net.ReadEntity()
	local _team = ent:GetNWInt("capTeam", -1)
	teamCredits[_team] = teamCredits[_team]+1000
	for k, v in pairs( player.GetAll() ) do
		if (v:GetInfo("mw_team") == tostring(_team)) then
			print("!!")
			net.Start("TeamCredits")
				net.WriteInt(teamCredits[_team] ,16)
			net.Send(v)
			v:PrintMessage( HUD_PRINTTALK, "///// Received 1000 water" )
		end
	end

	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	for i=0, 10 do
		util.Effect( "balloon_pop", effectdata )
	end
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos())
	effectdata:SetScale(10)
	util.Effect( "watersplash", effectdata )
	ent:Remove()
end )

net.Receive( "SpawnUnit", function( len, pl )
	local class = net.ReadString()
	local unit_index = net.ReadInt(16)
	local trace = net.ReadTable()
	local cost = net.ReadInt(16)
	local spawntime = net.ReadInt(16)
	local _team = net.ReadInt(8)
	local attach = net.ReadBool()
	local angle = net.ReadAngle()
	--print("Class: "..class.." - Trace Hitpos: "..tostring(trace.HitPos).." - Cost: "..cost.." - Team: ".._team)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base") then return end
	if (trace.Entity:GetClass() == "ent_melon_wall" and (attach == false and units[unit_index].welded_cost ~= -1 and unit_index < 9 --[[<< first building]])) then
		pl:PrintMessage( HUD_PRINTCENTER, "Cant spawn mobile units directly on buildings" )
		return
	end
	--newMarine.population = unit_population[melonTeam]
	local newMarine = SpawnUnitAtPos(class, unit_index, trace.HitPos + trace.HitNormal * 5, angle, cost, spawntime, _team, attach, trace.Entity)

	undo.Create("Melon Marine")
	 undo.AddEntity( newMarine )
	 undo.SetPlayer( pl)
	undo.Finish()
end )

function SpawnUnitAtPos (class, unit_index, pos, ang, cost, spawntime, _team, attach, parent, pl)

	local newMarine = ents.Create( class )
	if ( !IsValid( newMarine ) ) then return end -- Check whether we successfully made an entity, if not - bail

	newMarine:SetPos( pos)
	newMarine:SetAngles( ang)

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
	end
	melonTeam = _team

	newMarine.spawnTime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)

	if (unit_index == -1 or unit_index == -2) then --si es un motor o un propeller
		newMarine:GetPhysicsObject():EnableCollisions( false )
	end

	if (attach) then
		newMarine:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )
		if (tostring(parent) != "[NULL Entity]") then
			newMarine:Welded(newMarine, parent)
		else
			newMarine:SetMoveType(MOVETYPE_NONE)
			newMarine:Welded(newMarine, game.GetWorld())
		end
	end

	newMarine:Ini(_team)

	if (IsValid(pl)) then
		pl.melonTeam = _team
		newMarine:SetOwner(pl)
	end

	newMarine.realvalue = cost
	if (cvars.Bool("mw_admin_credit_cost")) then
		newMarine.value = cost
	else
		newMarine.value = 0
	end

	return newMarine
end

net.Receive( "ContraptionSave", function( len, pl )
	local name = net.ReadString()
	local entity = net.ReadEntity()

	--file.CreateDir( "melonwars/contraptions" )
	if (!entity:IsWorld()) then
		local entities = constraint.GetAllConstrainedEntities( entity )
		for k, v in pairs(entities) do
			if (v:GetClass() == "prop_physics") then
				v.realvalue = math.min(1000, v:GetPhysicsObject():GetMass()*10)
				--print("setting real value to "..math.min(1000, v:GetPhysicsObject():GetMass()*10))
			end
		end

		duplicator.SetLocalPos( pl:GetEyeTrace().HitPos )
		local duptable = duplicator.Copy(entity)
		local dubJSON = util.TableToJSON(duptable)
		duplicator.SetLocalPos( Vector(0,0,0) )
		net.Start("ContraptionSaveClient")
			net.WriteString(dubJSON)
			net.WriteString(name)
		net.Send(pl)
	end
end )

net.Receive( "ContraptionLoad", function( len, pl )

	undo.Create("Melon Marine")

	local fileJSON = net.ReadString()
	local duptable = util.JSONToTable( fileJSON )
	local ent = net.ReadEntity()
	local pos
	if (ent:GetClass() == "player") then
		pos = ent:GetEyeTrace().HitPos
	else
		pos = ent:GetPos()
	end
	duplicator.SetLocalPos( pos - Vector((duptable.Maxs.x+duptable.Mins.x)/2, (duptable.Maxs.y+duptable.Mins.y)/2, duptable.Mins.z-10))
	local paste = duplicator.Paste( pl, duptable.Entities, duptable.Constraints )
	duplicator.SetLocalPos( Vector(0,0,0) )
	local melonTeam = pl:GetInfoNum("mw_team", 0)
	local massHealthMultiplier = 1
	local massCostMultiplier = 10
	for k, v in pairs(paste) do
		if (v.Base == "ent_melon_base") then
			v:Ini(melonTeam)
		end
		if (v:GetClass() == "ent_melon_propeller" or v:GetClass() == "ent_melon_hover") then
			v:SetNWBool("done",true)
		end
		if (!string.StartWith( v:GetClass(), "ent_melon")) then
			v:SetColor(team_colors[melonTeam])
			v:SetNWInt("melonTeam", melonTeam)
			v:SetNWInt("propHP", math.min(1000,v:GetPhysicsObject():GetMass()*massHealthMultiplier))--max 1000 de vida
			v.realvalue = v:GetPhysicsObject():GetMass()*massCostMultiplier
		end
		if (ent:GetClass() == "player") then
			v:SetVar('targetPos', pos)
			v:SetNWVector('targetPos', pos)
		else
			v:SetVar('targetPos', ent.targetPos+Vector(0,0,1))
			v:SetNWVector('targetPos', ent.targetPos+Vector(0,0,1))
			v:SetVar('moving', true)
		end
		undo.AddEntity( v )
	end

	 undo.SetPlayer( pl)
	undo.Finish()
end )

net.Receive( "RequestContraptionLoadToAssembler", function( len, pl )
	local ent = net.ReadEntity()
	local _file = net.ReadString()
	ent.file = _file
	ent.player = pl
	print("RequestContraptionLoad")
	ent:SetNWBool("active", true)
	ent:SetNWFloat("nextSlowThink", CurTime()+net.ReadFloat())
	
	--net.Start("ContraptionLoad")
	--	net.WriteString(_file)
	--	net.WriteVector(ent:GetPos())
	--net.SendToServer()
end )

net.Receive( "SpawnProp", function( len, pl )
	local index = net.ReadInt(16)
	local trace = net.ReadTable()
	local cost = net.ReadInt(16)
	local _team = net.ReadInt(8)
	local propAngle = pl.propAngle

	local offset = base_offset[index]
	local xoffset = Vector(offset.x*(math.cos(propAngle.y/180*math.pi)), offset.x*(math.sin(propAngle.y/180*math.pi)),0)
	local yoffset = Vector(offset.y*(-math.sin(propAngle.y/180*math.pi)), offset.y*(math.cos(propAngle.y/180*math.pi)),0)
	offset = xoffset+yoffset+Vector(0,0,offset.z)
	SpawnProp(base_models[index], trace.HitPos + trace.HitNormal + offset, propAngle + base_angle[index], _team, trace.Entity, cost, pl)
end )

function SpawnProp(model, pos, ang, _team, parent, cost, pl)
	local newMarine = ents.Create( "ent_melon_wall" )
	if ( !IsValid( newMarine ) ) then return end -- Check whether we successfully made an entity, if not - bail
	--if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	
	newMarine:SetPos(pos)
	newMarine:SetAngles(ang)
	newMarine:SetModel(model)
	
	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	newMarine:SetNWInt("melonTeam", _team)

	newMarine:Spawn()

	if (parent != nil) then
		local weld = constraint.Weld( newMarine, parent, 0, 0, 0, true , false )
	else
		newMarine:SetMoveType(MOVETYPE_NONE)
		local weld = constraint.Weld( newMarine, game.GetWorld(), 0, 0, 0, true , false )
	end

	newMarine:SetVar("shotOffset", offset) 	--/////////////////////////////NOT WORKING

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
		pl.melonTeam = _team
		newMarine:SetOwner(pl)
		undo.Create("Melon Marine")
		 undo.AddEntity( newMarine )
		 undo.SetPlayer( pl)
		undo.Finish()
	end

	newMarine.realvalue = cost
	if (cvars.Bool("mw_admin_credit_cost")) then
		newMarine.value = cost
	else
		newMarine.value = 0
	end

	local effectdata = EffectData()
	effectdata:SetEntity( newMarine )
	util.Effect( "propspawn", effectdata )

	return newMarine
end

net.Receive( "SpawnBase", function( len, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	SpawnBaseAtPos(_team, trace.HitPos, pl)
end )

function SpawnBaseAtPos(_team, vector, pl)
	local newMarine = ents.Create( "ent_melon_main_building" )
	if ( !IsValid( newMarine ) ) then return end -- Check whether we successfully made an entity, if not - bail
	newMarine:SetPos( vector)
	
	sound.Play( "garrysmod/content_downloaded.wav", vector, 60, 90, 1 )

	melonTeam = _team

	newMarine.spawnTime = 0

	newMarine:Spawn()
	newMarine:SetNWInt("melonTeam", _team)

	newMarine:Ini(_team)

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
		undo.Create("Melon Marine")
		 undo.AddEntity( newMarine )
		 undo.SetPlayer( pl)
		undo.Finish()
	end
end

net.Receive( "SellEntity", function( len, pl )
	local entity = net.ReadEntity()
	local playerTeam = net.ReadInt(8)
	if (entity.Base == "ent_melon_base") then
		if (entity.canMove == true) then
			if (entity.gotHit or CurTime()-entity:GetCreationTime() >= 30 or entity.fired ~= false) then
				pl:PrintMessage( HUD_PRINTTALK, "///// Can't sell mobile units after 30 seconds, after they got hit, or after they fired." )
				sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
				entity = nil
			end
		end
	end
	if (entity ~= nil) then
		if (entity:GetClass() == "ent_melon_main_building" or (entity.Base ~= "ent_melon_base" and entity.Base ~= "ent_melon_prop_base" and entity:GetClass() ~= "prop_physics") or (entity:GetClass() == "prop_physics" and entity:GetNWInt("melonTeam", -1) ~= playerTeam)) then
			pl:PrintMessage( HUD_PRINTTALK, "///// That's not a sellable entity" )
			sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
			entity = nil
		end
	end
	if (entity ~= nil) then
		if (entity:GetClass() == "prop_physics" or entity.gotHit or CurTime()-entity:GetCreationTime() >= 30 or (entity.Base == "ent_melon_base" and entity.fired ~= false)) then --pregunta si NO se va a recivir el dinero de refund
			teamCredits[playerTeam] = teamCredits[playerTeam]+entity.value*0.25
			for k, v in pairs( player.GetAll() ) do
				if (v:GetInfo("mw_team") == tostring(entity:GetNWInt("melonTeam", 0))) then
					net.Start("TeamCredits")
						net.WriteInt(teamCredits[entity:GetNWInt("melonTeam", 0)] ,16)
					net.Send(v)
					v:PrintMessage( HUD_PRINTTALK, "///// "..tostring(entity.value*0.25).." Water Recovered" )
				end
			end
		end
		sound.Play( "garrysmod/balloon_pop_cute.wav", pl:GetPos(), 75, 100, 1 )
		local vPoint = Vector( 0, 0, 0 )
		local effectdata = EffectData()
		effectdata:SetOrigin( entity:GetPos() )
		for i=0, 5 do
			util.Effect( "balloon_pop", effectdata )
		end
		entity:Remove()
	end
end )
util.AddNetworkString( "SellEntity" )



net.Receive( "LegalizeContraption", function( len, pl )
	local traceEntity = pl:GetEyeTrace().Entity
	local melonTeam = net.ReadInt(8)
	
	local mass = 0 --precio por masa
	local cons = 0 --precio por construction tools

	local entities = constraint.GetAllConstrainedEntities( traceEntity )
	if (IsValid(traceEntity)) then
		for _, ent in pairs( entities ) do
			if (!freeze) then
				local c = ent:GetClass()
				if (c == "prop_physics") then
					if (ent:GetNWInt("melonTeam", -1) == -1) then
						local phys = ent:GetPhysicsObject()
						if (IsValid(phys)) then
							mass = mass+math.min(1000,phys:GetMass()) --max 1000 de vida
						end
					end
				end
			end
		end
	end
	local massCostMultiplier = 10
	local massHealthMultiplier = 1
	if (teamCredits[melonTeam] >= mass*massCostMultiplier or not cvars.Bool("mw_admin_credit_cost")) then
		if (IsValid(traceEntity)) then
			for _, ent in pairs( entities ) do
				if (string.StartWith( ent:GetClass(), "gmod_" ) or string.StartWith( ent:GetClass(), "prop_vehicle")) then
					ent:Remove()
				else
					if (!string.StartWith( ent:GetClass(), "ent_melon")) then
						ent:SetColor(team_colors[melonTeam])
						ent:SetNWInt("melonTeam", melonTeam)
						ent:SetNWInt("propHP", math.min(1000,ent:GetPhysicsObject():GetMass()*massHealthMultiplier))--max 1000 de vida
						--ent:GetPhysicsObject():SetMaterial( "ice" )
						ent.realvalue = ent:GetPhysicsObject():GetMass()*massCostMultiplier
					end
				end
			end
			if (cvars.Bool("mw_admin_credit_cost")) then
				teamCredits[melonTeam] = teamCredits[melonTeam]-mass*massCostMultiplier
				net.Start("TeamCredits")
					net.WriteInt(teamCredits[melonTeam] ,16)
				net.Send(pl)
			end
		end
	end
end )
util.AddNetworkString( "LegalizeContraption" )

concommand.Add( "mw_reset_credits", function( ply )
	if (ply:IsAdmin()) then
		teamCredits = {2000,2000,2000,2000,2000,2000,2000,2000}
		for k, v in pairs( player.GetAll() ) do
			net.Start("TeamCredits")
				net.WriteInt(2000 ,16)
			net.Send(v)
		end
	end

	local AI = ents.FindByClass( "ent_melon_singleplayer_AI" )
	if (IsValid(AI[1])) then
		AI[1]:CheaterAlert()
	end
end)

concommand.Add( "mw_singleplayer_waypoints_reposition", function( ply )
	local nodes = ents.FindByClass( "ent_melon_singleplayer_waypoint" )
	for k, v in pairs( nodes ) do
		v:SetPos(v.pos-Vector(0,0,10))
		v.time = 0
		v.pos = v:GetPos()
	end
end)

concommand.Add( "mw_singleplayer_waypoints_increment", function( ply )
	local nodes = ents.FindByClass( "ent_melon_singleplayer_waypoint" )
	for k, v in pairs( nodes ) do
		v.waypoint = v.waypoint+1
		v:SetNWInt("waypoint", v.waypoint)
	end
end)

concommand.Add( "mw_singleplayer_waypoints_decrement", function( ply )
	local nodes = ents.FindByClass( "ent_melon_singleplayer_waypoint" )
	for k, v in pairs( nodes ) do
		v.waypoint = v.waypoint-1
		v:SetNWInt("waypoint", v.waypoint)
	end
end)

concommand.Add( "mw_reset_power", function( ply )
	if (ply:IsAdmin()) then
		teamUnits = {0,0,0,0,0,0,0,0}
		--local allMelons = ents.GetAll()
		--for k, v in pairs(allMelons) do
	--	
	--		if (v.Base == "ent_melon_base") then
	--			prnt(v:GetVar("melonTeam"))
	--			--teamUnits[v:GetVar("melonTeam")] = teamUnits[v:GetVar("melonTeam")]
	--		end
	--	end
		
		for k, v in pairs( player.GetAll() ) do
			local melonTeam = v:GetInfoNum("mw_team", 0)
			net.Start("TeamUnits")
				net.WriteInt(teamUnits[melonTeam] ,16)
			net.Send(v)
		end

		--[[
		local AI = ents.FindByClass( "ent_melon_singleplayer_AI" )
		if (IsValid(AI[1])) then
			AI[1]:CheaterAlert()
		end
		]]
	end
end)

concommand.Add( "+mw_select", function( ply )
	ply.selecting = true
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
		mask = MASK_WATER+MASK_SOLID
	} )
	--print(trace.Entity)
	ply.selStart = trace.HitPos
	ply:SetNWVector("selStart", ply.selStart)
	ply:SetNWBool("selecting", ply.selecting)
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 100, 1 )
end)

net.Receive( "StartGame", function( len, pl )
	for k, v in pairs( player.GetAll() ) do
		net.Start("RestartQueue")
		net.Send(v)
		sound.Play( "garrysmod/content_downloaded.wav", v:GetPos()+Vector(0,0,45), 100, 40, 1)
		v:PrintMessage( HUD_PRINTCENTER, "The MelonWars match has begun!" )
		v:PrintMessage( HUD_PRINTTALK, "/////////////////////////////// The MelonWars match has begun!" )
	end
end)

net.Receive( "SandboxMode", function( len, pl )
	for k, v in pairs( player.GetAll() ) do
		sound.Play( "garrysmod/save_load1.wav", v:GetPos()+Vector(0,0,45), 100, 150, 1)
		v:PrintMessage( HUD_PRINTTALK, "////////// MelonWars options set to Sandbox" )
	end
end)

util.AddNetworkString( "Selection" )
concommand.Add( "-mw_select", function( ply )
	ply.selecting = false
	ply:SetNWBool("selecting", ply.selecting)

	--Encuentra todas las entidades en la esfera de selección

	local foundEnts = ents.FindInSphere((ply.selEnd+ply.selStart)/2, ply.selStart:Distance(ply.selEnd)/2+0.1 )
	local selectEnts = table.Copy( foundEnts )
	if (!ply:KeyDown(IN_SPEED)) then ply.foundMelons = {} end
	--Busca de esas entidades cuales son sandias, y cuales son del equipo correcto

	for k, v in pairs( selectEnts ) do
		if (v.moveType != MOVETYPE_NONE) then
			table.Add(foundEnts, constraint.GetAllConstrainedEntities( v ))
		end
	end

	for k, v in pairs( foundEnts ) do
		if (v.Base != "ent_melon_base_prop") then
			if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("melonTeam", 0) == ply:GetInfoNum( "mw_team", 0 )) then
				if (v:GetNWInt("melonTeam", 0) != 0) then
					table.insert(ply.foundMelons, v)
				end
			end
		end
	end
	--Le envia al client la lista de sandias para que pueda dibujar los halos
	net.Start("Selection")
		net.WriteInt(table.Count(ply.foundMelons),16)
		for k,v in pairs(ply.foundMelons) do
			net.WriteEntity(v)
		end
	net.Send(ply)
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 90, 1 )
	ply.selEnd = Vector(0,0,0)
	ply.selStart = Vector(0,0,0)
	ply:SetNWVector("selStart", Vector(0,0,0))
	ply:SetNWBool("selecting",  Vector(0,0,0))
end)

concommand.Add( "mw_typeselect", function( ply, cmd, args )
	if (args[1]) then
		ply.selecting = false
		ply:SetNWBool("selecting", false)

		--Encuentra todas las entidades en la esfera de selección
		print("Attempting type select with class "..args[1])
		
		local foundEnts = ents.FindInSphere(ply:GetEyeTrace().HitPos, 300)
		if (!ply:KeyDown(IN_SPEED)) then ply.foundMelons = {} end
		--Busca de esas entidades cuales son sandias, y cuales son del equipo correcto
		for k, v in pairs( foundEnts ) do
			if (v.Base == "ent_melon_base") then
				if (v:GetClass() == args[1]) then
					if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("melonTeam", 0) == ply:GetInfoNum( "mw_team", 0 )) then
						if (v:GetVar("canBeSelected") == true) then
							table.insert(ply.foundMelons, v)
						end
					end
				end
			end
		end
		--Le envia al client la lista de sandias para que pueda dibujar los halos
		net.Start("Selection")
			net.WriteInt(table.Count(ply.foundMelons),16)
			for k,v in pairs(ply.foundMelons) do
				net.WriteEntity(v)
			end
		net.Send(ply)
		sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 90, 1 )
		ply.selEnd = Vector(0,0,0)
		ply.selStart = Vector(0,0,0)
		ply:SetNWVector("selStart", Vector(0,0,0))
		ply:SetNWBool("selecting",  Vector(0,0,0))
	end
end)

concommand.Add( "mw_stop", function( ply )
	local stopedMelons = false
	if (ply.foundMelons ~= nil) then
		for k, v in pairs( ply.foundMelons ) do
			if (!IsValid(v)) then
				--Si murió, lo saco de la tabla
				table.remove(ply.foundMelons, k)
			else
				if (v.Base == "ent_melon_base") then
					--si sigue vivo, le doy la order
					--si no, mueve
					v:SetVar("targetPos", v:GetPos())
					v:SetNWVector("targetPos", v:GetPos())
					v:SetVar("moving", false)
					v:SetVar("chasing", false)
					v:SetVar("followEntity", v)
					v:SetNWEntity("followEntity", v)
					for i=1, 30 do
						v.rallyPoints[i] = Vector(0,0,0)
					end
					stopedMelons = true
				end
			end
		end
	end
		
	if (stopedMelons) then
		sound.Play( "buttons/button16.wav", ply:GetPos(), 75, 100, 1 )
	end
end)

concommand.Add( "mw_order", function( ply )
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
		mask = MASK_WATER+MASK_SOLID
	} )
	
	local movedMelons = false
	if (ply.foundMelons ~= nil) then
		for k, v in pairs( ply.foundMelons ) do
			if (v.Base == "ent_melon_base") then
				if (!IsValid(v)) then
					--Si murió, lo saco de la tabla
					table.remove(ply.foundMelons, k)
				else
					--si sigue vivo, le doy la order
					if (ply:KeyDown(IN_SPEED)) then
						local i = 30
						while i >= 0 do
							if (i == 0) then
								v.rallyPoints[1] = trace.HitPos
								v.moving = true
								movedMelons = true
								i = -1
							elseif (v.rallyPoints[i] ~= Vector(0,0,0)) then
								if (i < 30) then
									if (v.rallyPoints[i+1] == Vector(0,0,0)) then
										v.rallyPoints[i+1] = trace.HitPos
										movedMelons = true
										i = -1
									end
								end
							end
							i = i-1
						end
						PrintTable(v.rallyPoints)
					elseif (ply:KeyDown(IN_WALK)) then
						--si tenia apretado alt, dispara
						if (tostring(trace.Entity) == "Entity [0][worldspawn]") then
							--si se le apuntó al mundo, sacar objetivo
							v:SetVar("forcedTargetEntity", v)
							v:SetVar("targetEntity", v)
							v:SetVar("followEntity", v)
							v:SetNWEntity("followEntity", v)
							v:SetNWEntity("targetEntity", v)
							v:SetVar("chasing", false)
						else
							if (v:GetNWInt("melonTeam", 0) == trace.Entity:GetNWInt("melonTeam", 0)) then
								--si se le apuntó a algo, darle eso como objetivo
								v:SetVar("followEntity", trace.Entity)
								v:SetNWEntity("followEntity", trace.Entity)
								v:SetVar("forcedTargetEntity", v)
								v:SetVar("targetEntity", v)
								v:SetNWEntity("targetEntity", v)
								v:SetVar("chasing", false)
							else
								v:SetVar("followEntity", v)
								v:SetNWEntity("followEntity", v)
								v:SetVar("forcedTargetEntity", trace.Entity)
								v:SetVar("targetEntity", trace.Entity)
								v:SetNWEntity("targetEntity", trace.Entity)
								v:SetVar("chasing", true)
							end
						end
						movedMelons = true
					else
						--si no, mueve
						v:RemoveRallyPoints()
						v:SetVar("targetPos", trace.HitPos)
						v:SetNWVector("targetPos", trace.HitPos)
						v:SetVar("moving", true)
						v:SetVar("chasing", false)
						v:SetVar("followEntity", v)
						v:SetNWEntity("followEntity", v)
						movedMelons = true
					end
				end
			end
		end
	end
		
	if (movedMelons) then
		sound.Play( "garrysmod/ui_click.wav", ply:GetPos(), 75, 100, 1 )
	else
		sound.Play( "common/wpn_denyselect.wav", ply:GetPos(), 75, 100, 1 )
	end
end)

concommand.Add( "mw_save", function( ply )
	local allents = ents.GetAll()
	for k, v in pairs( allents ) do
		if (v:GetClass() == "ent_melon_main_building") then
			-- Si es una cierra, spawnear base
			local newMarker = ents.Create("ent_melonmarker_base")
			newMarker:SetPos(v:GetPos())
			newMarker:Spawn()
			newMarker:SetMelonTeam(v:GetNWInt("melonTeam", 0))
			v:Remove()
		elseif (v:GetClass() == "ent_melon_wall") then
			local newMarker = ents.Create("ent_melonmarker_base_prop")
			newMarker:SetPos(v:GetPos())
			newMarker:SetAngles(v:GetAngles())
			newMarker:Spawn()
			print("Parent: "..tostring(v.melonParent))
			newMarker:SetMelonTeam(v:GetNWInt("melonTeam", 0), v:GetModel(), v.melonParent)
			v:Remove()
		elseif (v.Base == "ent_melon_base") then
			local newMarker = ents.Create("ent_melonmarker_unit")
			newMarker:SetPos(v:GetPos())
			newMarker:Spawn()
			newMarker:SetMelonTeam(v:GetNWInt("melonTeam", 0), v:GetClass(), v:GetCollisionGroup() == COLLISION_GROUP_DISSOLVING)
			v:Remove()
		end
	end

	file.CreateDir( "melonwars" )
	print("melonwars/melonwars_save_"..GetConVarString( "mw_save_name" )..".txt")
	file.Write( "melonwars/melonwars_save_"..GetConVarString( "mw_save_name" )..".txt", gmsave.SaveMap( ply ))

	print("Stage saved to 'data/melonwars/melonwars_save_"..GetConVarString( "mw_save_name" )..".txt'. Remember to move it into your Campaign's folder.")
end)

concommand.Add( "mw_load", function( ply )
	--gmsave.LoadMap(  , "DATA") , ply )

	local tab
	--"data/melonwars_save_"
	if (file.Exists(GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".lua", "LUA")) then
		print("Finding file "..GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".lua")
		tab = util.JSONToTable( file.Read( GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".lua", "LUA"))
	elseif (file.Exists(GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".txt", "DATA")) then
		--"melonwars/<campaign>"
		print("Finding file "..GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".txt")
		tab = util.JSONToTable( file.Read( GetConVarString( "mw_save_path" ).."melonwars_save_"..GetConVarString( "mw_save_name" )..".txt", "DATA"))
	else
		print("File "..GetConVarString( "mw_save_name" ).." not found in addon folder, and file melonwars_save_"..GetConVarString( "mw_save_name" ).." not found in folder "..GetConVarString( "mw_save_path" ))
		return false
	end
	game.CleanUpMap()
	DisablePropCreateEffect = true
	duplicator.RemoveMapCreatedEntities()
	duplicator.Paste( ply, tab.Entities, tab.Constraints )
	teamUnits = {0,0,0,0,0,0,0,0}
	for k, v in pairs( player.GetAll() ) do
		local melonTeam = v:GetInfoNum("mw_team", 0)
		if (melonTeam != 0) then
			net.Start("TeamUnits")
				net.WriteInt(teamUnits[melonTeam] ,16)
			net.Send(v)
		end
	end
	if ( IsValid( ply ) ) then
		gmsave.PlayerLoad( ply, tab.Player )
	end

	local allents = ents.GetAll()
	for k, v in pairs( allents ) do
		if (v.Base == "ent_melon_base" or v:GetClass() == "ent_melon_wall") then
			v:Remove() -- Si quedó alguna entidad melon guardada la borra
		elseif (v:GetClass() == "ent_melonmarker_base") then
			SpawnBaseAtPos(v.melonTeam, v:GetPos())
			v:Remove()
		elseif (v:GetClass() == "ent_melonmarker_base_prop") then
			SpawnProp(v.melonModel, v:GetPos(), v:GetAngles(), v.melonTeam, nil, 0)
			v:Remove()
		elseif (v:GetClass() == "ent_melonmarker_unit") then
			if (!v.attach) then
				SpawnUnitAtPos(v.melonClass, 0, v:GetPos(), 0, 0, v.melonTeam, v.attach)
			else
				SpawnUnitAtPos(v.melonClass, 0, v:GetPos(), 0, 0, v.melonTeam, v.attach, v:GetParent())
			end
			v:Remove()
		elseif (v:GetClass() == "ent_melon_cap_point") then
			v:SetPos(v:GetPos()-Vector(0,0,70))
			v:Initialize()
		elseif (v:GetClass() == "ent_melon_outpost_point") then
			v:SetPos(v:GetPos()-Vector(0,0,162.5))
			v:Initialize()
		elseif (v:GetClass() == "ent_melon_mcguffin") then
			v:SetPos(v:GetPos()-Vector(0,0,100))
			v:Initialize()
		elseif (v:GetClass() == "ent_melon_water_tank") then
			v:SetPos(v:GetPos()-Vector(0,0,50))
			v:Initialize()
		elseif (v:GetClass() == "ent_melon_singleplayer_waypoint") then
			v:FindNext()
		end
	end
end)

concommand.Add( "mw_waypoints", function( ply )
	for k, v in pairs( ents.FindByClass( "ent_melon_singleplayer_waypoint" ) ) do
		v:FindNext()
	end
end)

concommand.Add( "mw_singleplayer_waypoints_visible", function( ply )
	for k, v in pairs( ents.FindByClass( "ent_melon_singleplayer_waypoint" ) ) do
		v:MakeWaypointVisible()
	end
end)


concommand.Add( "mw_admin_reset_teams", function( ply )
	for i=1,8 do
      teamgrid[i] = {}     -- create a new row
      for j=1,8 do
        teamgrid[i][j] = false
      end
    end
end)

hook.Add( "InitPostEntity", "start", function()	
	mw_save_name_custom = "melonwars_default_save"
	teamgrid = {}          -- create the matrix
    for i=1,8 do
      teamgrid[i] = {}     -- create a new row
      for j=1,8 do
        teamgrid[i][j] = false
      end
    end
	local tbl = player.GetAll()
	for k, v in pairs( tbl ) do
		v:PrintMessage( HUD_PRINTTALK, "____________________________________________________" )
		v:PrintMessage( HUD_PRINTTALK, "Melon Wars: RTS is running in this server." )
		v:PrintMessage( HUD_PRINTTALK, "Thanks for playing!" )
		v:PrintMessage( HUD_PRINTTALK, "____________________________________________________" )
	end
	print("=========================================================================================")
	print("Melon Wars: RTS is running in this server.")
	print("Thanks for using Melon Wars! Enjoy!")
	print("=========================================================================================")
end)

hook.Add( "Think", "update", function()	
	local tbl = player.GetAll()
	for k, v in pairs( tbl ) do
		if (v.selecting) then
			local trace = util.TraceLine( {
				start = v:EyePos(),
				endpos = v:EyePos() + v:EyeAngles():Forward() * 10000,
				filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
				mask = MASK_WATER+MASK_SOLID
			} )
			v.selEnd = trace.HitPos
			v:SetNWVector("selEnd", v.selEnd)
		end
	end

end)

net.Receive( "UpdateServerTeams", function( len, pl )
	--if (ply:IsAdmin()) then
		teamgrid = net.ReadTable()
		for k, v in pairs( player.GetAll() ) do
			net.Start("UpdateClientTeams")
				net.WriteTable(teamgrid)
			net.Send(v)
		end
	--end
end)

net.Receive( "RequestServerTeams", function( len, pl )
	net.Start("UpdateClientTeams")
		net.WriteTable(teamgrid)
	net.Send(pl)
end)

net.Receive( "ServerSetTeam", function( len, pl )
	local ent = net.ReadEntity()
	ent.melonTeam = net.ReadInt(4)
end)

net.Receive( "ServerSetWaypoint", function( len, pl )
	local ent = net.ReadEntity()
	ent.waypoint = net.ReadInt(8)
	ent.path = net.ReadInt(8)
	ent:SetNWInt("waypoint", ent.waypoint)
	ent:SetNWInt("path", ent.path)
end)

--[[net.Receive( "ServerSetSpawnpoint", function( len, pl )
	local ent = net.ReadEntity()
	ent.spawnpoint = net.ReadInt(8)
end)]]