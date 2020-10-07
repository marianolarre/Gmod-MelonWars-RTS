if engine.ActiveGamemode() == "sandbox"then

-- ( Some lines from the cl_spawnmenu.lua in the sandbox GM )
--function GM:Initialize()
--Net vars para mandar el equipo y los creditos al cliente
util.AddNetworkString( "MW_TeamCredits" )
util.AddNetworkString( "MW_TeamUpdate" )
util.AddNetworkString( "MW_TeamUnits" )
util.AddNetworkString( "MW_UpdateClientInfo" )
util.AddNetworkString( "MW_UpdateServerInfo" )

util.AddNetworkString( "MW_SelectContraption" )
util.AddNetworkString( "MW_RequestSelection" )
util.AddNetworkString( "MW_ReturnSelection" )
util.AddNetworkString( "MW_Order" )
util.AddNetworkString( "MW_Stop" )
util.AddNetworkString( "MW_SpawnUnit" )
util.AddNetworkString( "MW_UnitDecoration" )
util.AddNetworkString( "SpawnBase" )
util.AddNetworkString( "SpawnBaseGrandWar" )
util.AddNetworkString( "SpawnBaseUnit" )
util.AddNetworkString( "SpawnCapturePoint" )
util.AddNetworkString( "SpawnOutpost" )
util.AddNetworkString( "SpawnWaterTank" )
--util.AddNetworkString( "SpawnTransport" )
util.AddNetworkString( "MW_SpawnProp" )
util.AddNetworkString( "StartGame" )
util.AddNetworkString( "SandboxMode" )

util.AddNetworkString( "ToggleBarracks" )
util.AddNetworkString( "MW_Activate" )
util.AddNetworkString( "ActivateGate" )
util.AddNetworkString( "ActivateWaypoints" )
util.AddNetworkString( "PropellerReady" )
util.AddNetworkString( "UseWaterTank" )

util.AddNetworkString( "RestartQueue" )

util.AddNetworkString( "CalcContraption" )

util.AddNetworkString( "UpdateClientTeams" )
util.AddNetworkString( "UpdateServerTeams" )
util.AddNetworkString( "RequestServerTeams" )

// Contraptions
util.AddNetworkString( "ContraptionSave" )
util.AddNetworkString( "BeginContraptionSaveClient" )
util.AddNetworkString( "ContraptionSaveClient" )
util.AddNetworkString( "BeginContraptionLoad" )
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

util.AddNetworkString( "MWControlUnit" )
util.AddNetworkString( "MWControlShoot" )

util.AddNetworkString( "MWBrute" )
util.AddNetworkString( "MWMessage" )


--CreateConVar( "mw_save_name", "default", 8192, "Set the name of the file to save with 'mw_save'" )
--CreateConVar( "mw_save_name_custom", "default", 8192, "Set the name of the file to save with 'mw_save'" )
CreateConVar ( "mw_save_name", "default", 8192, "Set the name of the file to save with 'mw_save'" )
CreateConVar ( "mw_save_path", "default", 8192, "Set the path of the file to save with 'mw_save'" )

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
mw_team_names = {"Red", "Blue", "Yellow", "Green", "Purple", "Cyan", "Orange", "Pink"}
/*
mw_special_steam_decoration = {}
// Doorsday
mw_special_steam_decoration["STEAM_0:0:165277892"] = {
	prop = "models/props_c17/door01_left.mdl",
	scale = 0.2,
	chance = 0.2
}
*/
mw_special_steam_skins = {}
// Marum
mw_special_steam_skins["STEAM_0:0:29138250"] = {
	material = "models/shiny",
	trail = "trails/laser",
	length = 1,
	startSize = 60,
	endSize = 60,
	teamcolor = 0.1
}

// JonahSoldier
mw_special_steam_skins["STEAM_0:0:16826885"] = {
	material = "phoenix_storms/gear",
	trail = "trails/physbeam",
	length = 0.5,
	startSize = 15,
	endSize = 0,
	teamcolor = 1
}

// VarixDog
mw_special_steam_skins["STEAM_0:1:101608555"] = {
	material = "phoenix_storms/plastic",
	trail = "trails/lol",
	length = 0.5,
	startSize = 15,
	endSize = 15,
	teamcolor = 1
}

// Ratherial
mw_special_steam_skins["STEAM_0:1:127787235"] = {
	material = "hunter/myplastic",
	trail = "trails/laser",
	length = 0.5,
	startSize = 15,
	endSize = 15,
	teamcolor = 1
}

// EvilDuckGuy
mw_special_steam_skins["STEAM_0:0:460204826"] = {
	material = "models/combine_scanner/scanner_eye",
	trail = "effects/beam_generic01",
	length = 0.5,
	startSize = 15,
	endSize = 15,
	teamcolor = 1
}

// MerekiDor
mw_special_steam_skins["STEAM_0:1:93155236"] = {
	material = "phoenix_storms/cube",
	trail = "trails/smoke",
	length = 0.5,
	startSize = 15,
	endSize = 0,
	teamcolor = 0.5
}

function Initialize()
	mw_team_colors[0] = Color(100,100,100,255)
	mw_team_names[0] = {"Gray"}
end
hook.Add("Initialize", "Melonwars Initialize", Initialize)

function AddTabs()
	spawnmenu.AddToolTab( "MelonWars", "#Melonwarstab", "icon16/wrench.png" )
end
-- Hook the Tab to the Spawn Menu
hook.Add( "AddToolMenuTabs", "MelonWars", AddTabs )

mw_teamCredits = {2000,2000,2000,2000,2000,2000,2000,2000}
mw_teamUnits = {0,0,0,0,0,0,0,0}
teamUnlocks = {0,0,0,0,0,0,0,0}

teamgrid = teamgrid or {}

local function spawn( ply )
	ply.mw_hover = 0
	ply.mw_menu = 0
	ply.mw_selectTimer = 0
	ply.mw_spawntimer = 0
	ply.mw_frame = nil
	ply.mw_credits = 2000
	for k, v in pairs( player.GetAll() ) do
		net.Start("UpdateClientTeams")
			net.WriteTable(teamgrid)
		net.Send(ply)
	end
	util.PrecacheModel( "models/hunter/tubes/circle2x2.mdl" )
end
hook.Add( "PlayerInitialSpawn", "mw_initialspawn", spawn )
/*
local function playerSpawn( ply )
	if (cvars.Bool("mw_admin_player_colors")) then
		local _team = ply:GetInfoNum( "mw_team", 1 )
		ply:SetColor(mw_team_colors[_team])
	end
end
hook.Add( "PlayerSpawn", "mw_spawn", playerSpawn )*/

function MWSendMessage(pl, message, notificationType, length)
	net.Start("MWMessage")
		net.WriteString(message)
		net.WriteInt(notificationType,4)
		net.WriteFloat(length)
	net.Send(pl)
end

local function takedmg( target, dmginfo )
	if (dmginfo:GetAttacker():GetClass() ~= "player") then
		if (target.Base == "ent_melon_prop_base") then
			local multiplier = dmginfo:GetAttacker().buildingDamageMultiplier or 1
			local damage = dmginfo:GetDamage()*multiplier
			if (dmginfo:GetDamageType() == DMG_BLAST) then
				damage = damage*2
			elseif (dmginfo:GetDamageType() == DMG_BURN) then
				damage = damage*0.18
			end
			target:SetNWFloat( "health", target:GetNWFloat( "health", 1)-damage)
			if (target:GetNWFloat( "health", 1) <= 0) then
				if (not cvars.Bool("mw_admin_immortality")) then
					target:MW_PropDefaultDeathEffect( target )
				end
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
		if (target.chaseStance != nil and target.chaseStance == true) then
			target.chasing = true
			target.targetEntity = dmginfo:GetAttacker()
			if (target.targetEntity.owner != nil) then
				target.targetEntity = target.targetEntity.owner
			end
		end
	end
end
hook.Add( "EntityTakeDamage", "entitytakedmg", takedmg )

net.Receive( "MW_SelectContraption" , function(len, pl)
	local count = net.ReadUInt(16)
	local entities = {}
	for i=0, count do
		table.insert(entities, net.ReadEntity())
	end
	local extraEntities = {}
	if (istable(entities)) then
		for k, v in pairs(entities) do
			local constrained = constraint.GetAllConstrainedEntities(v)
			if (istable(constrained)) then
				for kk, vv in pairs(constrained) do
					if (!table.HasValue(entities, vv) and !table.HasValue(extraEntities, vv)) then
						print("Added constrained entity "..tostring(vv))
						table.insert(extraEntities, vv)
					end
				end
			end
		end
	end
	
	local extraCount = #extraEntities
	net.Start("MW_SelectContraption")
		net.WriteUInt(extraCount, 16)
		for k, v in pairs(extraEntities) do
			net.WriteEntity(v)
		end
	net.Send(pl)
end)

net.Receive("MW_RequestSelection", function(len, pl)

	local selectionID = net.ReadInt(8)
	local typeSelect = net.ReadString()
	local center = net.ReadVector()
	local radius = net.ReadFloat()

	local allFoundEntities = ents.FindInSphere( center, radius )
	local foundEntities = {}

	for k, v in ipairs(allFoundEntities) do
		if (string.StartWith( v:GetClass(), "ent_melon_" )) then
			if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", -1) == pl:GetInfoNum("mw_team", -2)) then
				if (v:GetClass() != "ent_melon_zone") then
					if (typeSelect == "nil" or typeSelect == v:GetClass()) then
						table.insert( foundEntities, v )
					end
				end
			end
		end
	end

	local foundCount = #foundEntities
	net.Start("MW_ReturnSelection")
		net.WriteInt(selectionID, 8)
		net.WriteUInt(foundCount, 16)
		for k, v in pairs(foundEntities) do
			net.WriteEntity(v)
		end
	net.Send(pl)
end)

net.Receive( "MW_Activate", function( len, pl )
	local ent = net.ReadEntity()
	ent:Actuate();
end)

net.Receive( "ActivateGate", function( len, pl )
	local ent = net.ReadEntity()
	ent:Actuate();
end)

net.Receive( "MW_UpdateClientInfo", function( len, pl )
	local a = net.ReadInt(8)
	//pl:SetColor(mw_team_colors[a])
	if (a != 0) then
		//WaterResetTest(mw_teamCredits[a])
		net.Start("MW_TeamCredits")
			net.WriteInt(mw_teamCredits[a] ,32)
		net.Send(pl)
		net.Start("MW_TeamUnits")
			net.WriteInt(mw_teamUnits[a] ,16)
		net.Send(pl)
	else
		net.Start("MW_TeamCredits")
			net.WriteInt(20000 ,32)
		net.Send(pl)
		net.Start("MW_TeamUnits")
			net.WriteInt(0 ,16)
		net.Send(pl)
	end
end )

function WaterResetTest(number)
	/*
	if (number == 0) then
		"This looks like a water reset. Please send this chunk of console code to Marum!"
	end
	"Sending credits to server. Setting amount to: "..number
	debug.Trace()
	"------------------------------------"*/
end

function MW_UpdateServerInfo(team, water)

end

net.Receive( "MW_UpdateServerInfo", function( len, pl )
	local a = net.ReadInt(8)
	mw_teamCredits[a] = net.ReadInt(32)
	--mw_teamUnits[a] = net.ReadInt(16)
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
	mw_teamCredits[_team] = mw_teamCredits[_team]+1000
	for k, v in pairs( player.GetAll() ) do
		if (v:GetInfo("mw_team") == tostring(_team)) then
			net.Start("MW_TeamCredits")
				net.WriteInt(mw_teamCredits[_team] ,32)
			net.Send(v)
			v:PrintMessage( HUD_PRINTTALK, "Received 1000 water" )
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

net.Receive( "MW_SpawnUnit", function( len, pl )
	local class = net.ReadString()
	local unit_index = net.ReadInt(16)
	local trace = net.ReadTable()
	local cost = net.ReadInt(16)
	local spawntime = net.ReadInt(16)
	local _team = net.ReadInt(8)
	local attach = net.ReadBool()
	local angle = net.ReadAngle()
	local position = net.ReadVector()
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base") then return end
	if (trace.Entity:GetClass() == "ent_melon_wall" and (attach == false and mw_units[unit_index].welded_cost ~= -1 and unit_index < 9 --[[<< first building]])) then
		pl:PrintMessage( HUD_PRINTCENTER, "Cant spawn mobile units directly on buildings" )
		return
	end

	--newMarine.population = unit_population[mw_melonTeam]
	local newMarine = SpawnUnitAtPos(class, unit_index, position/*trace.HitPos + trace.HitNormal * 5*/, angle, cost, spawntime, _team, attach, trace.Entity, pl)

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
	mw_melonTeam = _team

	newMarine.mw_spawntime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)
	newMarine:SetNWInt("mw_melonTeam", _team)

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
		pl.mw_melonTeam = _team
		if (class != "ent_melon_unit_transport") then // disable physgun grab / pickup for everything but except the unit transport
			newMarine:SetOwner(pl)
		end

		if (pl:GetInfo( "mw_enable_skin" ) == "1") then
			local _skin = mw_special_steam_skins[pl:SteamID()]
			if (_skin != nil) then
				if (_skin.material != nil) then
					newMarine:SkinMaterial(_skin.material)
				end
				if (_skin.trail != nil) then
					local color = Color(newMarine:GetColor().r*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().g*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().b*_skin.teamcolor+255*(1-_skin.teamcolor))
					util.SpriteTrail( newMarine, 0, color, false, _skin.startSize, _skin.endSize, _skin.length, 1 / _skin.startSize * 0.5, _skin.trail )
				end
			end
			/*_skin = mw_special_steam_decoration["STEAM_0:0:165277892"]//[pl:SteamID()]
			if (_skin != nil) then
				if (math.Rand(0, 1) < _skin.chance) then
					timer.Simple(1, function()
						print("Sending msg")
						net.Start("MW_UnitDecoration")
							net.WriteEntity(newMarine)
							net.WriteTable(_skin)
						net.Broadcast()
					end)
				end
			end*/
		end
	end

	newMarine.realvalue = cost
	if (cvars.Bool("mw_admin_credit_cost")) then
		newMarine.value = cost
	else
		newMarine.value = 0
	end

	return newMarine
end

function MW_CalculateContraptionValues(betadupetable, pl)
	local cost = 0
	local power = 0

	// Verify entities
	for k, v in pairs(betadupetable.Entities) do
		if (v.Class == "prop_physics") then
			cost = cost+v.Cost
		elseif (string.StartWith(v.Class, "ent_melon_")) then
			local unit_data =mw_units[mw_unit_ids[v.Class]]
			if (unit_data.welded_cost == -1 and (unit_data.contraptionPart == nil or unit_data.contraptionPart == false)) then
				return "A non weldable unit cant be part of a contraption", 0, 0
			else
				cost = cost+unit_data.welded_cost
				power = power+unit_data.population
			end
		end
	end

	// Verify constraints
	for k, v in pairs(betadupetable.Constraints) do
		local entities = betadupetable.Entities
		if (v.Type == "Weld") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
				constraint.Weld( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.forcelimit, v.nocollide, true )
			elseif (ent1isMelon and ent2isMelon) then
				// Units cant be welded to other units
				return "Units cant be welded to other units", 0, 0
			end

		elseif (v.Type == "Axis") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon or not ent2isMelon) then
			else
				// Units cant be welded to other units
				return "Units cant have Axis with other units", 0, 0
			end

		elseif (v.Type == "Ballsocket") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
			else
				// Units cant be welded to other units
				return "Units cant have Ballsockets", 0, 0
			end

		elseif (v.Type == "Slider") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
			else
				// Units cant be welded to other units
				return "Units cant have Sliders", 0, 0
			end

		elseif (v.Type == "NoCollide") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon or not ent2isMelon) then
			else
				// Units cant be welded to other units
				return "Units cant have No Collide with other units", 0, 0
			end
		end
	end

	return "success", cost, power
end

function MW_GetBetaContraptionTable(dupetable, pl)
	local betadupetable = {}

	// Save Entities
	betadupetable.Entities = {}

	for k, v in pairs(dupetable.Entities) do
		betadupetable.Entities[k] = {}
		betadupetable.Entities[k].Class = v.Class
		if (v.Class == "prop_physics") then
			betadupetable.Entities[k].EntIndex = k
			betadupetable.Entities[k].Angles = v.Angle
			betadupetable.Entities[k].Pos = v.Pos
			betadupetable.Entities[k].Model = v.Model
			betadupetable.Entities[k].Cost = v.realvalue
		elseif (string.StartWith(v.Class, "ent_melon_")) then
			betadupetable.Entities[k].EntIndex = k
			betadupetable.Entities[k].Angles = v.Angle
			betadupetable.Entities[k].Pos = v.Pos
		end
	end

	// Save Constraints
	betadupetable.Constraints = {}
	for k, v in pairs(dupetable.Constraints) do
		betadupetable.Constraints[k] = {}
		betadupetable.Constraints[k].Type = v.Type
		if (v.Type == "Weld") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].nocollide = v.nocollide
		elseif (v.Type == "Axis") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].LPos1 = v.LPos1
			betadupetable.Constraints[k].LPos2 = v.LPos2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].torquelimit = v.torquelimit
			betadupetable.Constraints[k].friction = v.friction
			betadupetable.Constraints[k].nocollide = v.nocollide
			betadupetable.Constraints[k].LocalAxis = v.LocalAxis
		elseif (v.Type == "Ballsocket") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].torquelimit = v.torquelimit
			betadupetable.Constraints[k].nocollide = v.nocollide
			betadupetable.Constraints[k].LPos = v.LPos
		elseif (v.Type == "Slider") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].LPos1 = v.LPos1
			betadupetable.Constraints[k].LPos2 = v.LPos2
			betadupetable.Constraints[k].width = v.width
			betadupetable.Constraints[k].material = v.material
		elseif (v.Type == "NoCollide") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
		end
	end

	// Data
	betadupetable.Maxs = dupetable.Maxs
	betadupetable.Mins = dupetable.Mins

	local result, cost, power = MW_CalculateContraptionValues(betadupetable,pl)

	if (result != "success") then
		print(result)
		MWSendMessage(pl, result, 1, 4)
	else
		MWSendMessage(pl, "Contraption saved succesfully", 0, 4)
	end

	betadupetable.Cost = cost
	betadupetable.Power = power

	return betadupetable
end

function MW_CreateContraptionFromTable(localPos, dupetable, pl)
	local entities = {}
	local constraints = {}

	// Spawn entities
	for k, v in pairs(dupetable.Entities) do
		local ent = ents.Create(v.Class)
		if (v.Class == "prop_physics") then
			ent:SetPos(localPos+v.Pos)
			ent:SetAngles(v.Angles)
			ent:SetModel(v.Model)
		elseif (string.StartWith(v.Class, "ent_melon_")) then
			ent:SetPos(localPos+v.Pos)
			ent:SetAngles(v.Angles)

		end
		ent:Spawn()
		entities[v.EntIndex] = ent
	end

	// Spawn constraints
	for k, v in pairs(dupetable.Constraints) do
		if (v.Type == "Weld") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1]:GetClass(), "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2]:GetClass(), "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
				constraint.Weld( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.forcelimit, v.nocollide, true )
			elseif (ent1isMelon and ent2isMelon) then
				// Units cant be welded to other units
				MWSendMessage(pl, "Units cant be welded to other units", NOTIFY_ERROR, 4)
				return {}, {}
			elseif (ent1isMelon) then
				entities[v.Ent1]:Welded(entities[v.Ent1], entities[v.Ent2])
			elseif (ent2isMelon) then
				entities[v.Ent2]:Welded(entities[v.Ent2], entities[v.Ent1])
			end

		elseif (v.Type == "Axis") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1]:GetClass(), "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2]:GetClass(), "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon or not ent2isMelon) then
				constraint.Axis( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.LPos1, v.LPos2, v.forcelimit, v.torquelimit, v.friction, v.nocollide, v.LocalAxis, true )
			else
				// Units cant be welded to other units
				MWSendMessage(pl, "Units cant have Axis with other units", NOTIFY_ERROR, 4)
				return {}, {}
			end

		elseif (v.Type == "Ballsocket") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1]:GetClass(), "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2]:GetClass(), "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
				constraint.Ballsocket( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.LPos, v.forcelimit, v.torquelimit, v.nocollide )
			else
				// Units cant be welded to other units
				MWSendMessage(pl, "Units cant have Ballsockets", NOTIFY_ERROR, 4)
				return {}, {}
			end

		elseif (v.Type == "Slider") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1]:GetClass(), "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2]:GetClass(), "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon and not ent2isMelon) then
				constraint.Slider( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.LPos1, v.LPos2, v.width, v.material )
			else
				// Units cant be welded to other units
				MWSendMessage(pl, "Units cant have Sliders", NOTIFY_ERROR, 4)
				return {}, {}
			end

		elseif (v.Type == "NoCollide") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1]:GetClass(), "ent_melon_")) then ent1isMelon=true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2]:GetClass(), "ent_melon_")) then ent2isMelon=true end

			if (not ent1isMelon or not ent2isMelon) then
				constraint.NoCollide( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2 )
			else
				// Units cant be welded to other units
				MWSendMessage(pl, "Units cant have No Collide with other units", NOTIFY_ERROR, 4)
				return {}, {}
			end
		end
	end

	return entities, constraints
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
			end
		end

		duplicator.SetLocalPos( pl:GetEyeTrace().HitPos )
		local dupetable = duplicator.Copy(entity)
		duplicator.SetLocalPos( Vector(0,0,0) )

		local dubJSON

		if (cvars.Bool("mw_admin_contraptions_beta")) then
			print("Saved contraption with the BETA method")
			
			local betadupetable = MW_GetBetaContraptionTable(dupetable, pl)

			dubJSON = util.TableToJSON(betadupetable)
			print(dubJSON)
		else
			print("Saved contraption with the CLASSIC method")
			dubJSON = util.TableToJSON(dupetable)
		end

		local text = dubJSON
		local compressed_text = util.Compress( text )
		if ( !compressed_text ) then compressed_text = text end
		local len = string.len( compressed_text )
		local send_size = 60000
		local parts = math.ceil( len / send_size )
		local start = 0
		net.Start( "BeginContraptionSaveClient" )
			net.WriteString(name)
			net.WriteEntity(pl)
		net.Send(pl)
		for i = 1, parts do
			local endbyte = math.min( start + send_size, len )
			local size = endbyte - start
			local data = compressed_text:sub( start + 1, endbyte + 1 )
			net.Start( "ContraptionSaveClient" )
				net.WriteBool( i == parts )
				net.WriteUInt( size, 16 )
				net.WriteData( data, size )
			net.Send(pl)
			start = endbyte
		end
	end
end )

mrtsMessageReceivingEntity = nil
mrtsMessageReceivingState = "idle"
mrtsNetworkBuffer = ""

net.Receive("BeginContraptionLoad", function()
	if (mrtsMessageReceivingState == "idle") then
		local pl = net.ReadEntity()
		mrtsMessageReceivingEntity = pl
		mrtsMessageReceivingState = tostring(pl)
		mrtsNetworkBuffer = ""
	end
end)

net.Receive( "ContraptionLoad", function( len, pl )

	undo.Create("Melon Marine")

	local last = net.ReadBool()
	local size = net.ReadUInt(16)
	local data = net.ReadData(size)

	//local text = util.Decompress(data)
	mrtsNetworkBuffer = mrtsNetworkBuffer..data
	if (last) then
		local text = util.Decompress(mrtsNetworkBuffer)
		local dupetable = util.JSONToTable( text )
		local ent = mrtsMessageReceivingEntity
		local pos
		if (ent:GetClass() == "player") then
			pos = ent:GetEyeTrace().HitPos
		else
			pos = ent:GetPos()
		end
		
		local paste
		local constraints

		local localpos = pos - Vector((dupetable.Maxs.x+dupetable.Mins.x)/2, (dupetable.Maxs.y+dupetable.Mins.y)/2, dupetable.Mins.z-10)
		if (cvars.Bool("mw_admin_contraptions_beta")) then
			paste, constraints = MW_CreateContraptionFromTable(localpos, dupetable, pl)
		else
			duplicator.SetLocalPos( localpos)
			paste = duplicator.Paste( player.GetByID( 0 ), dupetable.Entities, dupetable.Constraints )
			duplicator.SetLocalPos( Vector(0,0,0) )
		end
		
		local mw_melonTeam = pl:GetInfoNum("mw_team", 0)
		local massHealthMultiplier = 1
		local massCostMultiplier = 10
		for k, v in pairs(paste) do
			if (v.Base == "ent_melon_base") then
				v:Ini(mw_melonTeam)

				if (pl:GetInfo( "mw_enable_skin" ) == "1") then
					local _skin = mw_special_steam_skins[pl:SteamID()]
					if (_skin != nil) then
						if (_skin.material != nil) then
							v:SkinMaterial(_skin.material)
						end
						if (_skin.trail != nil) then
							local color = Color(v:GetColor().r*_skin.teamcolor+255*(1-_skin.teamcolor), v:GetColor().g*_skin.teamcolor+255*(1-_skin.teamcolor), v:GetColor().b*_skin.teamcolor+255*(1-_skin.teamcolor))
							util.SpriteTrail( v, 0, color, false, _skin.startSize, _skin.endSize, _skin.length, 1 / _skin.startSize * 0.5, _skin.trail )
						end
					end
				end
			end
			if (v:GetClass() == "ent_melon_propeller" or v:GetClass() == "ent_melon_hover") then
				v:SetNWBool("done",true)
			end
			if (!string.StartWith( v:GetClass(), "ent_melon")) then
				v:SetColor(mw_team_colors[mw_melonTeam])
				v:SetMaterial("")
				v:SetRenderFX(kRenderFxNone)
				v:SetNWInt("mw_melonTeam", mw_melonTeam)
				v:SetNWInt("propHP", math.min(1000,v:GetPhysicsObject():GetMass()*massHealthMultiplier))--max 1000 de vida
				v.realvalue = v:GetPhysicsObject():GetMass()*massCostMultiplier
				hook.Run("MelonWarsEntitySpawned", v)
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

		for k, v in pairs(paste) do
			v:GetPhysicsObject():EnableMotion(true)
		end

		mrtsMessageReceivingEntity = nil
		mrtsMessageReceivingState = "idle"
		mrtsNetworkBuffer = ""
	end
end )

net.Receive( "RequestContraptionLoadToAssembler", function( len, pl )
	local ent = net.ReadEntity()
	local powerCost = net.ReadUInt(16)
	local _file = net.ReadString()
	local time = net.ReadFloat()
	ent.file = _file
	ent.player = pl
	ent.powerCost = powerCost
	ent:SetNWBool("active", true)
	ent:SetNWFloat("nextSlowThink", CurTime()+time)
	ent:SetNWFloat("slowThinkTimer", time)
	--net.Start("ContraptionLoad")
	--	net.WriteString(_file)
	--	net.WriteVector(ent:GetPos())
	--net.SendToServer()
end )

net.Receive( "MW_SpawnProp", function( len, pl )
	local index = net.ReadInt(16)
	local trace = net.ReadTable()
	local cost = net.ReadInt(16)
	local _team = net.ReadInt(8)
	local spawntime = net.ReadInt(16)
	local propAngle = net.ReadAngle()

	local offset = Vector(0,0,mw_base_props[index].offset.z)
	if (cvars.Bool("mw_prop_offset") == true) then
		offset = mw_base_props[index].offset
	end
	local xoffset = Vector(offset.x*(math.cos(propAngle.y/180*math.pi)), offset.x*(math.sin(propAngle.y/180*math.pi)),0)
	local yoffset = Vector(offset.y*(-math.sin(propAngle.y/180*math.pi)), offset.y*(math.cos(propAngle.y/180*math.pi)),0)
	offset = xoffset+yoffset+Vector(0,0,offset.z)
	MW_SpawnProp(mw_base_props[index].model, trace.HitPos + trace.HitNormal + offset, propAngle + mw_base_props[index].angle, _team, trace.Entity, mw_base_props[index].hp, cost, pl, spawntime)
end )

function MW_SpawnProp(model, pos, ang, _team, parent, health, cost, pl, spawntime)
	local newMarine = ents.Create( "ent_melon_wall" )
	if ( !IsValid( newMarine ) ) then return end -- Check whether we successfully made an entity, if not - bail
	--if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	
	newMarine:SetPos(pos)
	newMarine:SetAngles(ang)
	newMarine:SetModel(model)
	newMarine.maxHP = health

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	newMarine:SetNWInt("mw_melonTeam", _team)

	newMarine.mw_spawntime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)

	if (parent != nil) then
		local weld = constraint.Weld( newMarine, parent, 0, 0, 0, true , false )
	else
		newMarine:SetMoveType(MOVETYPE_NONE)
		local weld = constraint.Weld( newMarine, game.GetWorld(), 0, 0, 0, true , false )
	end

	newMarine:SetVar("shotOffset", offset) 	--/////////////////////////////NOT WORKING

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
		pl.mw_melonTeam = _team
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
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, false, false)
end )

net.Receive( "SpawnBaseGrandWar", function( len, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, true, false)
end )

net.Receive( "SpawnBaseUnit", function( len, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, false, true)
end )

net.Receive( "SpawnCapturePoint", function( len, pl )
	local trace = net.ReadTable()
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	local e = ents.Create("ent_melon_cap_point")
	e:SetPos(trace.HitPos)
	e:Spawn()
end )

net.Receive( "SpawnOutpost", function( len, pl )
	local trace = net.ReadTable()
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	local e = ents.Create("ent_melon_outpost_point")
	e:SetPos(trace.HitPos)
	e:Spawn()
end )

net.Receive( "SpawnWaterTank", function( len, pl )
	local trace = net.ReadTable()
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	local e = ents.Create("ent_melon_water_tank")
	e:SetPos(trace.HitPos)
	e:Spawn()
end )

function MW_SpawnBaseAtPos(_team, vector, pl, grandwar, unit)

	local offset = Vector(0,0,0)

	local class = "ent_melon_main_building"
	if (grandwar) then
		class = "ent_melon_main_building_grand_war"
	end
	if (unit) then
		class = "ent_melon_main_unit"
		offset = Vector(0,0,50)
	end
	local newMarine = ents.Create( class )
	if ( !IsValid( newMarine ) ) then return end -- Check whether we successfully made an entity, if not - bail
	newMarine:SetPos( vector+offset )
	
	sound.Play( "garrysmod/content_downloaded.wav", vector, 60, 90, 1 )

	mw_melonTeam = _team

	newMarine.mw_spawntime = 0

	newMarine:Spawn()
	newMarine:SetNWInt("mw_melonTeam", _team)

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
				pl:PrintMessage( HUD_PRINTTALK, "Can't sell mobile mw_units after 30 seconds, after they got hit, or after they fired." )
				sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
				entity = nil
			end
		end
	end
	if (IsValid(entity)) then
		if (entity:GetClass() == "ent_melon_main_building" or (entity.Base ~= "ent_melon_base" and entity.Base ~= "ent_melon_prop_base" and entity.Base ~= "ent_melon_energy_base" and entity:GetClass() ~= "prop_physics") or (entity:GetClass() == "prop_physics" and entity:GetNWInt("mw_melonTeam", -1) ~= playerTeam)) then
			if (IsValid(pl)) then
				pl:PrintMessage( HUD_PRINTTALK, "That's not a sellable entity" )
				sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
			end
			entity = nil
		end
	end
	if (entity ~= nil) then
		if (entity:GetClass() == "prop_physics" or entity.gotHit or CurTime()-entity:GetCreationTime() >= 30 or (entity.Base == "ent_melon_base" and entity.fired ~= false)) then --pregunta si NO se va a recivir el dinero de refund NULL ENTITY
			mw_teamCredits[playerTeam] = mw_teamCredits[playerTeam]+entity.value*0.25
			for k, v in pairs( player.GetAll() ) do
				if (v:GetInfo("mw_team") == tostring(entity:GetNWInt("mw_melonTeam", 0))) then
					net.Start("MW_TeamCredits")
						net.WriteInt(mw_teamCredits[entity:GetNWInt("mw_melonTeam", 0)] ,32)
					net.Send(v)
					v:PrintMessage( HUD_PRINTTALK, tostring(entity.value*0.25).." Water Recovered" )
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
	local mw_melonTeam = net.ReadInt(8)
	
	local mass = 0 --precio por masa
	local cons = 0 --precio por construction tools

	local entities = constraint.GetAllConstrainedEntities( traceEntity )
	if (IsValid(traceEntity)) then
		for _, ent in pairs( entities ) do
			if (!freeze) then
				local c = ent:GetClass()
				if (c == "prop_physics") then
					if (ent:GetNWInt("mw_melonTeam", -1) == -1) then
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
	if (mw_teamCredits[mw_melonTeam] >= mass*massCostMultiplier or not cvars.Bool("mw_admin_credit_cost")) then
		if (IsValid(traceEntity)) then
			for _, ent in pairs( entities ) do
				if (string.StartWith( ent:GetClass(), "gmod_" ) or string.StartWith( ent:GetClass(), "prop_vehicle")) then
					ent:Remove()
				else
					if (!string.StartWith( ent:GetClass(), "ent_melon")) then
						ent:SetColor(mw_team_colors[mw_melonTeam])
						ent:SetNWInt("mw_melonTeam", mw_melonTeam)
						ent:SetNWInt("propHP", math.min(1000,ent:GetPhysicsObject():GetMass()*massHealthMultiplier))--max 1000 de vida
						--ent:GetPhysicsObject():SetMaterial( "ice" )
						ent.realvalue = ent:GetPhysicsObject():GetMass()*massCostMultiplier
					end
				end
			end
			if (cvars.Bool("mw_admin_credit_cost")) then
				mw_teamCredits[mw_melonTeam] = mw_teamCredits[mw_melonTeam]-mass*massCostMultiplier
				net.Start("MW_TeamCredits")
					net.WriteInt(mw_teamCredits[mw_melonTeam] ,32)
				net.Send(pl)
			end
		end
	end
end )
util.AddNetworkString( "LegalizeContraption" )

concommand.Add( "mw_reset_credits", function( ply )
	if (ply:IsAdmin()) then
		local c = cvars.Number("mw_admin_starting_credits")
		mw_teamCredits = {c,c,c,c,c,c,c,c}
		for k, v in pairs( player.GetAll() ) do
			net.Start("MW_TeamCredits")
				net.WriteInt(c ,32)
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
		mw_teamUnits = {0,0,0,0,0,0,0,0}
		--local allMelons = ents.GetAll()
		--for k, v in pairs(allMelons) do
	--	
	--		if (v.Base == "ent_melon_base") then
	--			prnt(v:GetVar("mw_melonTeam"))
	--			--mw_teamUnits[v:GetVar("mw_melonTeam")] = mw_teamUnits[v:GetVar("mw_melonTeam")]
	--		end
	--	end
		
		for k, v in pairs( player.GetAll() ) do
			local mw_melonTeam = v:GetInfoNum("mw_team", 0)
			net.Start("MW_TeamUnits")
				net.WriteInt(mw_teamUnits[mw_melonTeam] ,32)
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
	ply.mw_selecting = true
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
		mask = MASK_WATER+MASK_SOLID
	} )
	ply.mw_selStart = trace.HitPos
	ply:SetNWVector("mw_selStart", ply.mw_selStart)
	ply:SetNWBool("mw_selecting", ply.mw_selecting)
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 100, 1 )
end)

net.Receive( "StartGame", function( len, pl )

	for i=0, 4 do
		timer.Simple(i, function()
			for k, v in pairs( player.GetAll() ) do
				v:PrintMessage( HUD_PRINTCENTER, "Match starts in "..(5-i) )
				/*if (cvars.Bool("mw_admin_player_colors")) then
					local _team = v:GetInfoNum( "mw_team", 1 )
					v:SetColor(mw_team_colors[_team])
				end*/
			end
		end)
	end
	timer.Simple(5, function ()
		for k, v in pairs( player.GetAll() ) do
			RunConsoleCommand("mw_admin_playing", 1)
			RunConsoleCommand("mw_admin_move_any_team", 0)
			RunConsoleCommand("mw_admin_credit_cost", 1)
			RunConsoleCommand("mw_admin_allow_free_placing", 0)
			RunConsoleCommand("mw_admin_spawn_time", 1)
			RunConsoleCommand("mw_admin_immortality", 0)
			RunConsoleCommand("mw_reset_credits")
			net.Start("RestartQueue")
			net.Send(v)
			sound.Play( "garrysmod/content_downloaded.wav", v:GetPos()+Vector(0,0,45), 100, 40, 1)
			v:PrintMessage( HUD_PRINTCENTER, "The MelonWars match has begun!" )
			v:PrintMessage( HUD_PRINTTALK, "==The MelonWars match has begun!==" )
		end
	end)
end)

net.Receive( "SandboxMode", function( len, pl )
	for k, v in pairs( player.GetAll() ) do
		sound.Play( "garrysmod/save_load1.wav", v:GetPos()+Vector(0,0,45), 100, 150, 1)
		v:PrintMessage( HUD_PRINTTALK, "==MelonWars options set to Sandbox==" )
	end
end)
/*
util.AddNetworkString( "Selection" )
concommand.Add( "-mw_select", function( ply )
	ply.mw_selecting = false
	ply:SetNWBool("mw_selecting", ply.mw_selecting)

	--Encuentra todas las entidades en la esfera de selección

	local foundEnts = ents.FindInSphere((ply.mw_selEnd+ply.mw_selStart)/2, ply.mw_selStart:Distance(ply.mw_selEnd)/2+0.1 )
	local selectEnts = table.Copy( foundEnts )
	if (!ply:KeyDown(IN_SPEED)) then ply.foundMelons = {} end
	--Busca de esas entidades cuales son sandias, y cuales son del equipo correcto

	for k, v in pairs( selectEnts ) do
		if (v.moveType != MOVETYPE_NONE) then
			local tbl = constraint.GetAllConstrainedEntities( v )
			if (istable(tbl)) then
				for kk, vv in pairs (tbl) do
					if (!table.HasValue(selectEnts, vv)) then
						table.insert(foundEnts, vv)
					end
				end
			end
		end
	end

	for k, v in pairs( foundEnts ) do
		if (v.Base == "ent_melon_base") then
			if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", -1) == ply:GetInfoNum( "mw_team", -1 )) then
				--if (v:GetNWInt("mw_melonTeam", 0) != 0) then
					table.insert(ply.foundMelons, v)
					--"Added "..tostring(v).." succesfully"
				--else
				--"Didn't add "..tostring(v).." because it had no team"
				--end
			--else
			--"Didn't add "..tostring(v).." because it wasn't my team"
			end
		--else
		--"Didn't add "..tostring(v).." because it was a base prop"
		end
	end

	//PrintTable(ply.foundMelons)
	--Le envia al client la lista de sandias para que pueda dibujar los halos
	net.Start("Selection")
		net.WriteInt(table.Count(ply.foundMelons),16)
		for k,v in pairs(ply.foundMelons) do
			net.WriteEntity(v)
		end
	net.Send(ply)
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 90, 1 )
	ply.mw_selEnd = Vector(0,0,0)
	ply.mw_selStart = Vector(0,0,0)
	ply:SetNWVector("mw_selStart", Vector(0,0,0))
	ply:SetNWBool("mw_selecting",  Vector(0,0,0))
end)
*/
/*
concommand.Add( "mw_typeselect", function( ply, cmd, args )
	if (args[1]) then
		ply.mw_selecting = false
		ply:SetNWBool("mw_selecting", false)

		--Encuentra todas las entidades en la esfera de selección
		
		local foundEnts = ents.FindInSphere(ply:GetEyeTrace().HitPos, 300)
		if (!ply:KeyDown(IN_SPEED)) then ply.foundMelons = {} end
		--Busca de esas entidades cuales son sandias, y cuales son del equipo correcto
		for k, v in pairs( foundEnts ) do
			if (v.Base == "ent_melon_base") then
				if (v:GetClass() == args[1]) then
					if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", 0) == ply:GetInfoNum( "mw_team", 0 )) then
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
		ply.mw_selEnd = Vector(0,0,0)
		ply.mw_selStart = Vector(0,0,0)
		ply:SetNWVector("mw_selStart", Vector(0,0,0))
		ply:SetNWBool("mw_selecting",  Vector(0,0,0))
	end
end)
*/
//concommand.Add( "mw_stop", function( ply )
net.Receive("MW_Stop", function( len, ply )
	local stopedMelons = false

	foundMelons = {}
	local entity = net.ReadEntity();
	while (not entity:IsWorld() and entity:IsValid() and entity != nil) do
		if (string.StartWith(entity:GetClass(), "ent_melon_")) then
			table.insert(foundMelons, entity)
		end
		entity = net.ReadEntity();
	end

	//local foundMelons = ply.foundMelons

	if (foundMelons ~= nil) then
		for k, v in pairs( foundMelons ) do
			if (!IsValid(v)) then
				--Si murió, lo saco de la tabla
				table.remove(foundMelons, k)
			else
				if (v.Base == "ent_melon_base") then
					--si sigue vivo, le doy la order
					--si no, mueve
					v:SetVar("targetPos", v:GetPos())
					v:SetNWVector("targetPos", v:GetPos())
					v:SetVar("moving", false)
					v:SetNWBool("moving", false)
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

//concommand.Add( "mw_order", function( ply )
net.Receive("MW_Order", function( len, ply )

	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
		mask = MASK_WATER+MASK_SOLID
	} )

	//local foundMelons = ply.foundMelons
	foundMelons = {}
	local position = net.ReadVector();
	local rally = net.ReadBool()
	local alt = net.ReadBool()
	local entity = net.ReadEntity();
	while (not entity:IsWorld() and entity:IsValid() and entity != nil) do
		if (string.StartWith(entity:GetClass(), "ent_melon_")) then
			table.insert(foundMelons, entity)
		end
		entity = net.ReadEntity();
	end

	if (foundMelons ~= nil) then
		for k, v in pairs( foundMelons ) do
			if (!IsValid(v) or not string.StartWith(v:GetClass(), "ent_melon_")) then
				--Si murió, lo saco de la tabla
				table.remove(foundMelons, k)
			end
		end

		if (rally) then
			for k, v in pairs( foundMelons ) do
				local i = 30
				while i >= 0 do
					if (v.rallyPoints != nil) then
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
					end
					i = i-1
				end
			end
		elseif (alt) then
			for k, v in pairs( foundMelons ) do
				if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
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
						if (v:GetNWInt("mw_melonTeam", 0) == trace.Entity:GetNWInt("mw_melonTeam", 0)) then
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
				end
			end
		/*elseif (ply:KeyDown(IN_DUCK)) then
			local center = Vector(0,0,0)
			local i = 0
			for k, v in pairs( foundMelons ) do
				if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
					center = center+v:GetPos()
					i = i+1
				end
			end
			center = center/i
			local distance = 50
			for k, v in pairs( foundMelons ) do
				if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
					--local clampedMagnitude = math.max(100,math.min(500,(v:GetPos()-center):Length()))
					distance = distance + 25/(1+distance*0.1)
					local newTarget = v:GetPos()+(v:GetPos()-center):GetNormalized()*distance
					v:RemoveRallyPoints()
					v:SetVar("targetPos", newTarget)
					v:SetNWVector("targetPos", newTarget)
					v:SetVar("moving", true)
					v:SetNWBool("moving", true)
					v:SetVar("chasing", false)
					v:SetVar("followEntity", v)
					v:SetNWEntity("followEntity", v)
					movedMelons = true
				end
			end*/
		else
			for k, v in pairs( foundMelons ) do
				--si no, mueve
				if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
					if (v.RemoveRallyPoints != nil) then
						v:RemoveRallyPoints()
					end
					v:SetVar("targetPos", trace.HitPos)
					v:SetNWVector("targetPos", trace.HitPos)
					v:SetVar("moving", true)
					v:SetNWBool("moving", true)
					v:SetVar("chasing", false)
					v:SetVar("followEntity", v)
					v:SetNWEntity("followEntity", v)
					movedMelons = true
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
			newMarker:SetMelonTeam(v:GetNWInt("mw_melonTeam", 0))
			v:Remove()
		elseif (v:GetClass() == "ent_melon_wall") then
			local newMarker = ents.Create("ent_melonmarker_base_prop")
			newMarker:SetPos(v:GetPos())
			newMarker:SetAngles(v:GetAngles())
			newMarker:Spawn()
			newMarker:SetMelonTeam(v:GetNWInt("mw_melonTeam", 0), v:GetModel(), v.melonParent)
			v:Remove()
		elseif (v.Base == "ent_melon_base") then
			local newMarker = ents.Create("ent_melonmarker_unit")
			newMarker:SetPos(v:GetPos())
			newMarker:SetAngles(v:GetAngles())
			newMarker:Spawn()
			newMarker:SetMelonTeam(v:GetNWInt("mw_melonTeam", 0), v:GetClass(), v:GetCollisionGroup() == COLLISION_GROUP_DISSOLVING)
			v:Remove()
		elseif (v.Base == "ent_melon_energy_base") then
			local newMarker = ents.Create("ent_melonmarker_energy_unit")
			newMarker:SetPos(v:GetPos())
			newMarker:Spawn()
			newMarker:SetMelonTeam(v:GetNWInt("mw_melonTeam", 0), v:GetClass(), v:GetCollisionGroup() == COLLISION_GROUP_DISSOLVING)
			v:Remove()
		end
	end

	file.CreateDir( "melonwars" )
	file.Write( GetConVarString( "mw_save_name" )..".txt", gmsave.SaveMap( ply ))
	print("Stage saved to '"..GetConVarString( "mw_save_name" )..".txt'. Remember to move it into your Campaign's folder.")
end)

concommand.Add( "mw_load", function( ply )
	--gmsave.LoadMap(  , "DATA") , ply )

	local tab
	--"data/melonwars_save_"
	if (file.Exists(/*GetConVarString( "mw_save_path" ).."melonwars_save_"..*/GetConVarString( "mw_save_name" )..".lua", "LUA")) then
		tab = util.JSONToTable( file.Read( /*GetConVarString( "mw_save_path" ).."melonwars_save_"..*/GetConVarString( "mw_save_name" )..".lua", "LUA"))
	elseif (file.Exists(/*GetConVarString( "mw_save_path" ).."melonwars_save_"..*/GetConVarString( "mw_save_name" ), "DATA")) then
		--"melonwars/<campaign>"
		tab = util.JSONToTable( file.Read( /*GetConVarString( "mw_save_path" ).."melonwars_save_"..*/GetConVarString( "mw_save_name" ), "DATA"))
	else
		print("File "..GetConVarString( "mw_save_name" ).." not found in addon folder")
		return false
	end
	game.CleanUpMap()
	DisablePropCreateEffect = true
	duplicator.RemoveMapCreatedEntities()
	duplicator.Paste( ply, tab.Entities, tab.Constraints )
	mw_teamUnits = {0,0,0,0,0,0,0,0}
	mw_electric_network = {}
	for k, v in pairs( player.GetAll() ) do
		local mw_melonTeam = v:GetInfoNum("mw_team", 0)
		if (mw_melonTeam != 0) then
			net.Start("MW_TeamUnits")
				net.WriteInt(mw_teamUnits[mw_melonTeam] ,16)
			net.Send(v)
		end
	end
	if ( IsValid( ply ) ) then
		gmsave.PlayerLoad( ply, tab.Player )
	end

	local allents = ents.GetAll()
	for k, v in pairs( allents ) do
		if (v.Base == "ent_melon_base" or v.Base == "ent_melon_energy_base" or v:GetClass() == "ent_melon_wall") then
			v:Remove() -- Si quedó alguna entidad melon guardada la borra
		elseif (v:GetClass() == "ent_melonmarker_base") then
			MW_SpawnBaseAtPos(v.mw_melonTeam, v:GetPos())
			v:Remove()
		elseif (v:GetClass() == "ent_melonmarker_base_prop") then
			MW_SpawnProp(v.melonModel, v:GetPos(), v:GetAngles(), v.mw_melonTeam, nil, 0)
			v:Remove()
		elseif (v:GetClass() == "ent_melonmarker_unit") then
			if (!v.attach) then
				SpawnUnitAtPos(v.melonClass, 0, v:GetPos(), v:GetAngles(), 0, 0, v.mw_melonTeam, v.attach)
			else
				SpawnUnitAtPos(v.melonClass, 0, v:GetPos(), v:GetAngles(), 0, 0, v.mw_melonTeam, v.attach, v:GetParent())
			end
			v:Remove()
		elseif (v:GetClass() == "ent_melonmarker_energy_unit") then
			SpawnUnitAtPos(v.melonClass, 0, v:GetPos(), v:GetAngles(), 0, 0, v.mw_melonTeam, v.attach)
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
end)

hook.Add( "Think", "update", function()	
	local tbl = player.GetAll()
	for k, v in pairs( tbl ) do
		if (v.mw_selecting) then
			local trace = util.TraceLine( {
				start = v:EyePos(),
				endpos = v:EyePos() + v:EyeAngles():Forward() * 10000,
				filter = function( ent ) if ( ent:GetClass() != "player" ) then return true end end,
				mask = MASK_WATER+MASK_SOLID
			} )
			v.mw_selEnd = trace.HitPos
			v:SetNWVector("mw_selEnd", v.mw_selEnd)
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
	ent.mw_melonTeam = net.ReadInt(4)
end)

net.Receive( "ServerSetWaypoint", function( len, pl )
	local ent = net.ReadEntity()
	ent.waypoint = net.ReadInt(8)
	ent.path = net.ReadInt(8)
	ent:SetNWInt("waypoint", ent.waypoint)
	ent:SetNWInt("path", ent.path)
end)

local function MWSign(x)
	if (x > 0) then return 1 end
	if (x < 0) then return -1 end
	return 0
end

local function MW_Move( ply, mv )
	if (IsValid(ply.controllingUnit)) then
		local cUnit = ply.controllingUnit

		if (mv:GetForwardSpeed() != 0 or mv:GetSideSpeed() != 0) then
			local pos = cUnit:GetPos()+(mv:GetMoveAngles():Forward()*MWSign(mv:GetForwardSpeed())+mv:GetMoveAngles():Right()*MWSign(mv:GetSideSpeed()))*15
			cUnit:SetVar('targetPos', pos)
			cUnit:SetNWVector('targetPos', pos)
			cUnit:SetVar('moving', true)
		end

		if (mv:KeyDown(IN_JUMP)) then
			cUnit:Unstuck()
		end

		return true
	end
end

hook.Add( "Move", "MWCalcView", MW_Move )

net.Receive( "MWControlUnit" , function(len, pl)
	local u = net.ReadEntity()
	pl.controllingUnit = u
	u.ai = false
	net.Start("MWControlUnit")
		net.WriteEntity(u)
	net.Send(pl)
end)

net.Receive( "MWControlShoot" , function(len, pl)
	local u = net.ReadEntity()
	local pos = net.ReadVector()
	u:Shoot(u, pos)
end)

net.Receive("MWBrute", function(len, pl)
	pl:Kill()
end)

end