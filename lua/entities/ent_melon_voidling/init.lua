AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/hunter/misc/sphere025x025.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.deathSound = "npc/antlion/pain2.wav"
	self.shotSound = "npc/antlion/attack_single1.wav"

	self.speed = 120
	self.range = 150
	self.maxHP = 3
	self.damageDeal = 20
	self.materialString = "phoenix_storms/wire/pcb_blue"

	self.captureSpeed = 0.1

	self.dootChance = 0

	self.sphereRadius = 4

	self.canBeSelected = false

	MW_Setup ( self )

	self:SetMaterial("phoenix_storms/wire/pcb_blue")
end

function ENT:SkinMaterial()

end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
	if (ent:GetNWInt("mw_melonTeam", 0) == 0 and ent.targetEntity == nil) then
		local pos = ent:GetPos()+VectorRand(-100, 100)
		ent:RemoveRallyPoints()
		ent:SetVar("targetPos", pos)
		ent:SetNWVector("targetPos", pos)
		ent:SetVar("moving", true)
		ent:SetNWBool("moving", true)
		ent:SetVar("chasing", false)
		ent:SetVar("followEntity", ent)
		ent:SetNWEntity("followEntity", ent)
		ent.damage = 0.1
	end
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SkinMaterial()
	self:SetMaterial("")
end

function ENT:Shoot ( ent, forceTargetPos )
	self.phys:SetDamping(0, 0)
	self:SetVelocity(Vector(0,0,0))
	self.phys:ApplyForceCenter(Vector(0,0,115)+(self.targetEntity:GetPos()-self:GetPos())*3/self.phys:GetMass())
	self.fired = true
	timer.Simple(0.4, function()
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
				if (self.forceExplode or tostring( self.targetEntity ) ~= "[NULL Entity]") then
					self.targetEntity.damage = self.damageDeal
					sound.Play( self.shotSound, self:GetPos(), 75, 145 )
					MW_Die ( self )
				end
			end
		end
	end )
end

function ENT:DeathEffect ( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( ent.deathEffect, effectdata )
	sound.Play( ent.deathSound, ent:GetPos(), 20, 145 )
	ent:Remove()
end