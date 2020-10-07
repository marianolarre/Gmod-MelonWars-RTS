AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function PropDefaults( ent )

	ent.hp = 1
	ent:SetNWFloat( "maxhealth", 1 )
	ent:SetNWFloat( "health", 1 )

	ent.shotOffset = Vector(0,0,0)
	ent.modelString = "models/props_junk/watermelon01.mdl"
	ent.materialString = "models/debug/debugwhite"

	ent:SetMaterial( "Models/effects/comball_sphere" )

	ent.onFire = false
	
	ent.deathEffect = "cball_explode"
	
	ent.damage = 0
	
	ent.Angles = Angle(0,0,0)
end

function PropSetup( ent )
	
	if (SERVER) then
		ent:SetNWEntity( "targetEntity", ent.targetEntity )
		
		--ent:SetModel( ent.modelString )
		
		ent:SetSolid( SOLID_VPHYSICS )         -- Toolbox
		
		ent:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		
		if (ent.moveType == 0) then
			local weld = constraint.Weld( ent, game.GetWorld(), 0, 0, 0, true , false )
			canMove = false
		end
		
		ent.phys = ent:GetPhysicsObject()
		if (IsValid(ent.phys)) then
			ent.phys:Wake()
		end

		if (ent.changeAngles) then
			ent:SetAngles( ent.Angles )
		end

		if (cvars.Number("mw_admin_spawn_time") == 1 and ent.mw_spawntime ~= nil) then
			timer.Simple( ent.mw_spawntime-CurTime(), function()
				if (IsValid(ent)) then	
					MW_PropSpawn(ent)
				end
			end)
		else
			MW_PropSpawn(ent)
		end
	end
	
	local mw_melonTeam = ent:GetNWInt("mw_melonTeam", 0)
		
	local newColor = mw_team_colors[mw_melonTeam]
	ent:SetColor(newColor)
end

function MW_PropSpawn(ent)
	if (SERVER) then
		
		ent:SetMoveType( ent.moveType )   -- after all, gmod is a physics
		
		ent:SetMaterial(ent.materialString)
		ent.spawned = true
		ent.HP = ent.maxHP
		ent:SetNWFloat( "maxhealth", ent.maxHP )
		ent:SetNWFloat( "health", ent.HP )

		hook.Run("MelonWarsEntitySpawned", ent)
	end
end

function ENT:MW_PropDefaultDeathEffect( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( ent.deathEffect, effectdata )
	sound.Play( ent.deathSound, ent:GetPos() )
	ent:Remove()
end

function PropDie( ent )
	if (not cvars.Bool("mw_admin_immortality")) then
		ent:MW_PropDefaultDeathEffect ( ent )
	end
end
--[[
function ENT:OnTakeDamage( damage )
	if (damage:GetDamage() > 0) then
		if ((damage:GetAttacker():GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not damage:GetAttacker():GetVar('careForFriendlyFire')) and not damage:GetAttacker():IsPlayer()) then 
			local HP = self:GetNWFloat("health", 1) - damage:GetDamage()
			self:SetNWFloat( "health", HP )
			if (HP <= 0) then
				PropDie (self)
			end
		end
	end
end]]

function ENT:OnRemove()
	if (SERVER) then
		if (self:GetNWFloat("health", 1) == self:GetNWFloat("maxhealth", 1) and CurTime()-self:GetCreationTime() < 30) then
			if (mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] != nil) then
				mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] = mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)]+self.value
			end
			for k, v in pairs( player.GetAll() ) do
				if (self:GetNWInt("mw_melonTeam", 0) != 0) then
					if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
						net.Start("MW_TeamCredits")
							net.WriteInt(mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
						net.Send(v)
						v:PrintMessage( HUD_PRINTTALK, "///// "..self.value.." Water Refunded" )
					end
				end
			end
		end
	end
end