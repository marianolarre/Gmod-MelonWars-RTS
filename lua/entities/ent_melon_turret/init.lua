AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/combine_turrets/ground_turret.mdl"
	self.speed = 80
	self.spread = 7--20
	self.damageDeal = 10
	self.maxHP = 45
	self.range = 500
	self.population = 2
	//self.Angles = Angle(180,180,0)	
	//self:SetPos(self:GetPos()+ Vector(0,0,0))
	self.shotSound = "weapons/ar1/ar1_dist2.wav"
	self.tracer = "AR2Tracer"
	
	self.shotOffset = Vector(0,0,15)
	
	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 1

	MW_Setup ( self )
	//self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
end

function ENT:Shoot ( ent )
	MW_DefaultShoot(ent)
	local angle = (ent.targetEntity:GetPos()-self:GetPos()):Angle() + Angle(180,180,0)	
	self:SetAngles( Angle(-angle.x, angle.y, angle.z) )
	/*MW_DefaultShoot(ent)
	local angle = (ent.targetEntity:GetPos()-self:GetPos()):Angle() + Angle(180,180,0)	
	self:SetAngles( Angle(-angle.x, angle.y, angle.z) )
	for i = 1, 3 do
		timer.Simple( i/4, function()
			if (IsValid(ent)) then
				if (IsValid(ent.targetEntity)) then
					MW_DefaultShoot(ent)
					local angle = (ent.targetEntity:GetPos()-self:GetPos()):Angle() + Angle(180,180,0)	
					self:SetAngles( Angle(-angle.x, angle.y, angle.z) )
				end
			end
		end)
	end*/
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end