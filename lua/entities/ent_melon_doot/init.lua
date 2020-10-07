AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/Gibs/HGIBS.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.deathSound = "npc/zombie/zombie_pain4.wav"
	self.shotSound = "npc/zombie/claw_strike3.wav"

	self.speed = 105
	self.range = 60
	self.maxHP = 10
	self.damageDeal = 2
	self.materialString = ""

	self.captureSpeed = 0

	self.dootChance = 0

	self.sphereRadius = 4

	self.meleeAi = true
	self.maxChaseDistance = 1600

	self.canBeSelected = false

	MW_Setup ( self )
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
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		MW_DefaultShoot ( ent, forceTargetPos )
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
	end
end

function ENT:DeathEffect ( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( ent.deathEffect, effectdata )
	sound.Play( ent.deathSound, ent:GetPos(), 75, 255 )
	ent:Remove()
end