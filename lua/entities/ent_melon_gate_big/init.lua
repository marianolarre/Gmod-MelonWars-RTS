AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_phx/construct/metal_plate2x4.mdl"--"models/props_c17/TrapPropeller_Engine.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 200
	self.force = 100

	//self:SetAngles(self:GetAngles()+Angle(90,0,0))

	//local offset = Vector(0,0,42)
	//self:SetPos(self:GetPos()+offset)

	self.closedpos = self:GetPos()
	self.openedpos = self:GetPos()+Vector(0,0,150)

	self.maxHP = 250

	self.open = false
	self:SetNWBool("open", self.open)
	self.process = 0
	self.population = 0

	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,0))

	self.damping = 4
	
	MW_Energy_Setup ( self )
	
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+50, self:GetColor().g/2+50, self:GetColor().b/2+50, 255))
end

function ENT:SlowThink ( ent )
	--MW_UnitDefaultThink ( ent )
end

function ENT:Actuate ()
	--if (self.process <= 0) then
		self.process = 5-self.process
		self.open = !self.open
		self:SetNWBool("open", self.open)
	--end
end

function ENT:Update()
	if (self.process > 0) then
		if (self:DrainPower(1)) then
			self.process = self.process - 0.2
			if (self.process < 0) then
				self.process = 0
			end
			local percent = self.process/5
			if (!self.open) then
				self:SetPos(self.openedpos*percent+self.closedpos*(1-percent))
			else
				self:SetPos(self.openedpos*(1-percent)+self.closedpos*(percent))
			end
		end
	end
	self:Energy_Set_State()
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end