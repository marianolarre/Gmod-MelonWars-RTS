AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/xqm/rails/trackball_1.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 80
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 40
	self.range = 400
	self.minRange = 200

	self.ai_chases = false

	self.sphereRadius = 15
	
	self.careForWalls = true
	
	self.nextShot = CurTime()+2
	self.fireDelay = 3

	self.shotOffset = Vector(0,0,10)
	
	self.population = 3
	
	self.shotSound = "weapons/ar2/ar2_altfire.wav"
	self.tracer = "AR2Tracer"
	
	self.slowThinkTimer = 1
	
	MW_Setup ( self )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		--------------------------------------------------------Disparar
		if (forcedTargetPos != nil) then
			local targets = ents.FindInSphere( forcedTargetPos, 3 )
			ent.targetEntity = nil
			for k, v in pairs(targets) do
				if (not ent:SameTeam(v)) then
					ent.targetEntity = v
					break;
				end
			end
		end

		if (ent.nextShot < CurTime()) then
			
			if (IsValid(ent.targetEntity)) then

				sound.Play( ent.shotSound, ent:GetPos() )
			
				local targetPos = ent.targetEntity:GetPos()
				if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
					targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
				end
				
				local bullet = ents.Create( "ent_melonbullet_missile" )
				if ( !IsValid( bullet ) ) then return end -- Check whether we successfully made an entity, if not - bail
				bullet:SetPos( ent:GetPos() + Vector(0,0,10) )
				bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
				bullet:Spawn()
				bullet:SetNWEntity("target", ent.targetEntity)
				bullet.owner = ent
				ent.fired = true
				ent.nextShot = CurTime()+ent.fireDelay
			end
		end
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end