AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/mechanics/wheels/wheel_spike_48.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.deathSound = "npc/antlion_guard/angry1.wav"
	self.shotSound = "npc/antlion_guard/shove1.wav"
	self.maxHP = 100
	self.speed = 70
	self.range = 100

	self.damageDeal = 40
	self.buildingDamageMultiplier = 1.5

	self.population = 3

	self.captureSpeed = 2

	//print("My Initialization")

	MW_Setup ( self )

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )

	self:SetMaterial("phoenix_storms/wire/pcb_blue")
end

function ENT:SkinMaterial()

end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forceTargetPos )
	self.phys:SetDamping(0, 0)
	self:SetVelocity(Vector(0,0,0))
	self.phys:ApplyForceCenter(Vector(0,0,115)+(self.targetEntity:GetPos()-self:GetPos())*3*self.phys:GetMass())
	self.fired = true
	timer.Simple(0.2, function()
		if (IsValid(self.targetEntity)) then
			self:Explode()
		end
	end)
end

function ENT:Explode()
	timer.Simple( 0.1, function()
		if (IsValid(self)) then
			if (!self.forceExplode and !IsValid(self.targetEntity)) then
				self.targetEntity = nil
				self.nextSlowThink = CurTime()+0.1
				return false
			else
				MW_DefaultShoot ( self, forceTargetPos )
			end
		end
	end )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end