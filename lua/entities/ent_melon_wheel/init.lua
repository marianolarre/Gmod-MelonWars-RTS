AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/XQM/airplanewheel1.mdl"--"models/props_c17/TrapPropeller_Engine.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = false
	self.canShoot = false
	self.speed = 600
	self.thrustforce = 0.003

	self.population = 0

	self.materialString = ""

	//self:SetAngles(self:GetAngles()+Angle(0,0,0))

	//local offset = Vector(0,-0.8,0)
	//offset:Rotate(self:GetAngles())
	//self:SetPos(self:GetPos()+offset)

	self.captureSpeed = 0

	self.maxHP = 80

	self.damping = 0.05
	self.angularDamping = 10000

	MW_Setup ( self )

	self:GetPhysicsObject():SetMass(30)

	self.moving = false;

	--self.weld = nil
end

function ENT:SlowThink ( ent )
	--MW_UnitDefaultThink ( ent )
end

function ENT:Welded( ent, parent )
	//local weld = constraint.Weld( ent, parent, 0, 0, 0, true , false )

	--ent.canMove = false

	//ent.parent = parent
	ent.phys:SetMaterial("rubber")

	local LPos1 = Vector(0,0,0)
	local LVector = Vector(1,0,0)
	local axis = constraint.Axis(self, parent, 0, 0, LPos1, LPos1, 0, 0, 0, 1, LVector, false)

	//self.weld = constraint.Weld( self, parent, 0, 0, 0, true , false )
	--Resta su poblacion para luego sumar la nueva
	MW_UpdatePopulation(-ent.population, mw_melonTeam)
	ent.population = math.ceil(ent.population/2)
	MW_UpdatePopulation(ent.population, mw_melonTeam)
end

function ENT:OnFinishMovement()
	self.phys:SetMaterial("rubber")
	if (self.weld == nil or self.weld == false) then
		self.weld = constraint.Weld( self, self.parent, 0, 0, 0, true , false )
	end
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:PhysicsUpdate()
	local vel = self.phys:GetVelocity()
	local forward = self:GetAngles():Forward()
	local dot = vel:GetNormalized():Dot(forward)
	self.phys:ApplyForceCenter(-forward*dot*self.phys:GetMass()*vel:Length()*0.1)
end

function ENT:Update (ent)
	if (self.moving == true) then
		if (self.parent == nil) then
			local constr = constraint.FindConstraint( self, "Axis" )
			if (IsValid(constr)) then
				self.parent = constr.Ent2
			end
		end
		if (self.weld != nil or self.weld == false) then
			constraint.RemoveConstraints( self, "Weld" )
			self.weld = nil
			ent.phys:SetMaterial("ice")
		end
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end