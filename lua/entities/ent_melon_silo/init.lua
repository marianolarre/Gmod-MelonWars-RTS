AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(255,50,255,255),Color(100,255,255,255),Color(255,120,0,255),Color(10,30,70,255)}

function ENT:Initialize()
		
	self.slowThinkTimer = 2

	self.mw_melonTeam = 0
	
	self.nextSlowThink = 0

	self.launchingTeam = 0
	self.launching = false
	
	self:SetModel( "models/hunter/triangles/trapezium3x3x1.mdl" )
	
	--self:SetAngles(Angle(90,0,0))
	//self:SetPos(self:GetPos()+Vector(0,0,35))
	
	self:SetMaterial("phoenix_storms/stripes")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:AlliedTeams(myTeam, otherTeam)
	if (myTeam == otherTeam) then
		return true
	end
	if (myTeam == 0 or otherTeam == 0) then
		return false
	end
	return teamgrid[myTeam][otherTeam];
end

function ENT:PhysicsCollide( data, phys )
	if (not self.launching) then
		if (string.StartWith(data.HitEntity:GetClass(), "ent_melon_")) then
			if (data.HitEntity.canMove) then
				if (data.HitEntity.carryingMelonium) then
					data.HitEntity:SetNWFloat("mw_sick", 30)
					data.HitEntity.carryingMelonium = false
					data.HitEntity.meloniumLamp:Remove()

					self.launchingTeam = data.HitEntity:GetNWInt("mw_melonTeam", 0)
					self.launching = true
					self:SetNWFloat("countdown", CurTime()+15)
					self:SetNWBool("launching", true)

					for k, v in pairs( player.GetAll() ) do
						v:PrintMessage( HUD_PRINTCENTER, "Launching Melonium Missile" )
						sound.Play( "buttons/lever6.wav", v:GetPos(), 75, 100, 1 )
					end

					for i=3, 15, 3 do
						timer.Simple(i,function()
							sound.Play( "ambient/alarms/klaxon1.wav", self:GetPos(), 75, 100, 1 )
						end)	
					end
					
					timer.Simple(15, function()
						
						self.launching = false
						self:SetNWBool("launching", false)

						local foundBases = ents.FindByClass("ent_melon_main_building")
						table.Add(foundBases, ents.FindByClass("ent_melon_main_building_grand_war"))

						local healthiest = nil
						local mostHealth = 0
						for k, v in pairs(foundBases) do
							if (not self:AlliedTeams(self.launchingTeam, v:GetNWInt("mw_melonTeam", 0))) then
								if (healthiest == nil or v:GetNWFloat("health", 0) > mostHealth) then
									healthiest = v
									mostHealth = v:GetNWFloat("health", 0)
								end
							end
						end

						if (IsValid(healthiest)) then
							local bullet = ents.Create( "ent_melonbullet_melonium_missile" )
							if ( !IsValid( bullet ) ) then return end -- Check whether we successfully made an entity, if not - bail
							bullet:SetPos( self:GetPos() + Vector(0,0,10) )
							bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
							bullet:Spawn()
							bullet:SetNWEntity("target", healthiest)

							for k, v in pairs( player.GetAll() ) do
								sound.Play( "ambient/alarms/klaxon1.wav", v:GetPos(), 75, 100, 1 )
								sound.Play( "weapons/rpg/rocketfire1.wav", v:GetPos(), 75, 100, 1 )
							end
						end
					end)
				end
			end
		end
	end
end