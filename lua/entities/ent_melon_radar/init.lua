AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_trainstation/trainstation_column001.mdl"
	self.speed = 80
	self.spread = 10
	self.damageDeal = 3
	self.maxHP = 40
	self.range = 1000
	//self.Angles = Angle(0,0,0)	
	self.shotSound = "weapons/ar1/ar1_dist2.wav"
	self.tracer = "AR2Tracer"
	
	self.shotOffset = Vector(0,0,15)
	//self:SetPos(self:GetPos()+Vector(0,0,-5))

	self.careForFriendlyFire = false
	self.careForWalls = false
	
	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 1
	self.deficit = 0

	self.population = 0
	self:SetNWVector("energyPos", Vector(0,0,62.5))
	
	MW_Energy_Setup ( self )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)

end

function ENT:SlowThink ( ent )
	local energyCost = 2

	self:SetNWBool("working", mw_electric_network[self.network].energy > 0)

	if (self:DrainPower(energyCost)) then
		MW_UnitDefaultThink ( ent )
	end

	self:Energy_Set_State()
end

function ENT:Shoot ( ent )
	self:DrainPower(20)
	self:CreateAlert (ent.targetEntity:GetPos(), ent:GetNWInt("mw_melonTeam", 0))
	self.nextSlowThink = CurTime()+5
	self:SetNWInt("energy", 0)
	self:SetNWString("message", "ALERT")
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:CreateAlert (pos, _team)
	self:PlayHudSound("ambient/alarms/doomsday_lift_alarm.wav", 0.1, 100, _team)
	local alert = ents.Create( "ent_melon_HUD_alert" )
	alert:SetPos(pos+Vector(0,0,100))
	alert:Spawn()
	alert:SetNWInt("drawTeam", _team)
end