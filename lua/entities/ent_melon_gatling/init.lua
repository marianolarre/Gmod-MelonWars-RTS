AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/Mechanics/gears/gear12x24.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 80
	self.spread = 15
	self.damageDeal = 3
	self.maxHP = 50
	self.range = 250
	
	self.shotOffset = Vector(0,0,10)

	self.population = 2
	self.buildingDamageMultiplier = 0.8

	self.shotSound = "weapons/smg1/smg1_fire1.wav"
	self.tracer = "AR2Tracer"
	
	self.slowThinkTimer = 1
	self.spinup = 0.2
	self.maxspinup = 8
	self.minspinup = 0.3

	MW_Setup ( self )

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	self.slowThinkTimer = self.spinup
	if (self.spinup > self.minspinup) then
		self.spinup = self.spinup - 0.2
		if (self.spinup < self.minspinup) then
			self.spinup = self.minspinup
		end
	end
	MW_UnitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		//MW_DefaultShoot ( ent, forcedTargetPos )
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
		for i = 0, 2 do
			timer.Simple( i*self.spinup/2, function()
				if (IsValid(ent)) then
					MW_DefaultShoot ( ent, forcedTargetPos )
				end
			end)
		end
		if (self.spinup < self.maxspinup) then
			self.spinup = self.spinup * 1.2 + 0.2
			if (self.spinup > self.maxspinup) then
				self.spinup = self.maxspinup
			end
		end
	end
end

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 10000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*100))

	self:DefaultPhysicsUpdate()
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end