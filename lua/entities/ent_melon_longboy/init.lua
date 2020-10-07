AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_trainstation/trainstation_ornament001.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 60
	self.spread = 10
	self.damageDeal = 2

	self.energyCost = 500

	self.maxHP = 150
	self.range = 1000
	self.minRange = 300

	self.ai_chases = false

	self.careForWalls = false
	
	self.nextShot = CurTime()+2
	self.fireDelay = 10

	self.shotOffset = Vector(0,0,10)
	
	self.population = 5
	
	self.shotSound = "weapons/ar2/ar2_altfire.wav"
	self.tracer = "AR2Tracer"
	
	self.slowThinkTimer = 1

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 2500)
	self:SetNWBool("mw_active", true)
	self:SetNWFloat("mw_ready", 0)

	MW_Setup ( self )

	self.phys:SetDamping(10,100000)
	self.phys:SetMaterial("gmod_ice")
end

function ENT:Actuate()
	self:SetNWBool("mw_active", not self:GetNWBool("mw_active", false))
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	if (not self.moving) then
		local ready = self:GetNWFloat("mw_ready", 0)
		if (ready < 1) then
			self:SetNWFloat("mw_ready", ready+0.1)
			if (self:GetNWFloat("mw_ready", 0) > 1) then
				self:SetNWFloat("mw_ready", 1)
			end
		end
	else
		self:SetNWFloat("mw_ready", 0)
	end
	
	if (self:GetNWInt("mw_charge",0) >= self.energyCost and self:GetNWFloat("mw_ready", 0) >= 1 and self:GetNWBool("mw_active", false) == true) then
		MW_UnitDefaultThink ( ent )
	end
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

				ent:SetNWInt("mw_charge",ent:GetNWInt("mw_charge",0)-self.energyCost)
				
				local bullet = ents.Create( "ent_melonbullet_longboy" )
				if ( !IsValid( bullet ) ) then return end -- Check whether we successfully made an entity, if not - bail
				bullet:SetPos( ent:GetPos() + Vector(0,0,80) )
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

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 2000000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*300))

	self:DefaultPhysicsUpdate()
end