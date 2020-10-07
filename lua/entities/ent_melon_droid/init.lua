AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_c17/utilityconnecter006c.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	
	self.shotSound = "weapons/stunstick/stunstick_impact2.wav"

	self.maxHP = 40
	self.speed = 90

	self.sphereRadius = 7
	self.damageDeal = 2
	self.slowThinkTimer = 2
	self.fireDelay = 0.5

	self.captureSpeed = 0.25

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 200)
	self.energyCost = 10

	self.population = 2

	//print("My Initialization")

	MW_Setup ( self )

	self.phys:SetDamping(10,100000)
	self.phys:SetMaterial("gmod_ice")
end

function ENT:SlowThink ( ent )
	if (self:GetNWInt("mw_charge",0) >= self.energyCost) then
		MW_UnitDefaultThink ( ent )
	end
end

function ENT:Shoot ( ent, forceTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		MW_DefaultShoot ( ent, forceTargetPos )
		ent:SetNWInt("mw_charge",ent:GetNWInt("mw_charge",0)-self.energyCost)
		ent.nextSlowThink = CurTime()+ent.fireDelay
		ent.nextControlShoot = CurTime()+ent.fireDelay
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 1000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*10))

	self:DefaultPhysicsUpdate()
end