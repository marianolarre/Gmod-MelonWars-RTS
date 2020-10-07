AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.speed = 125

	self.modelString = "models/props_junk/watermelon01.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	
	self.population = 1
	
	self.height = self:GetPos().z
	self.delayedForce = 0

	self.dropdown = 0

	self.sphereRadius = 7

	self.captureSpeed = 2

	MW_Setup ( self )

	self:GetPhysicsObject():EnableGravity( false )
end

function ENT:SpecificThink()
	self.phys:Wake()
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2, self:GetColor().g/2, self:GetColor().b/2, 255))
end

function ENT:SlowThink ( ent )
	if (cvars.Bool("mw_admin_playing") ) then
		MW_UnitDefaultThink ( ent )
		if (self.dropdown > 0) then
			self.dropdown = self.dropdown-1
		end
		if ((ent:GetPos():Distance(ent.targetPos)) < 160) then
			self:FinishMovement()
		end
	end
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		MW_DefaultShoot ( ent, forcedTargetPos )
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:Unstuck()
	if (self.dropdown == 0) then
		self.dropdown = 2
	end
end

function ENT:PhysicsUpdate()
	
	if (cvars.Bool("mw_admin_playing") ) then
	--if (self.moving == true) then

		self:DefaultPhysicsUpdate()

		local hoverdistance = 150
		local hoverforce = 1
		local phys = self.phys
		local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos()+Vector(0,0,-hoverdistance*2),
		filter = function( ent )
			local ph = ent:GetPhysicsObject()
			if (IsValid(ph)) then
				if ( not ent:GetPhysicsObject():IsMoveable() ) then
					return true
				end
			end
		end,
		mask = bit.bor(MASK_SOLID,MASK_WATER)
		} )

		if (not IsValid(tr.Entity) or not string.StartWith( tr.Entity:GetClass(),  "ent_melon" )) then
			self.height = tr.HitPos.z
		end

		local force = 0
		local distance = self:GetPos().z - self.height

		if (self.dropdown > 0) then
			hoverdistance = 50
		elseif (self.dropdown < 0) then
			self.dropdown = 0
		end
		
		if (distance < hoverdistance) then
			force = -(distance-hoverdistance)*hoverforce
			phys:ApplyForceCenter(Vector(0,0,-phys:GetVelocity().z*0.8))
		else
			force = -1
		end
		
		//if (force > self.delayedForce) then
			self.delayedForce = (self.delayedForce*2+force)/3
		//else
			//self.delayedForce = self.delayedForce*0.7
		//end

		phys:ApplyForceCenter(Vector(0,0,self.delayedForce))
	--end
	else
		self.phys:Sleep()
	end
end