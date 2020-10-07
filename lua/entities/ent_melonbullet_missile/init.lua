AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/weapons/w_missile.mdl")
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	
	self.careForFriendlyFire = false

	self.speed = 12
	self.damageDeal = 3
	self.maxHP = 20
	self.random = Vector(math.random()/2-1/4, math.random()/2-1/4, math.random()/6+0.1)
	
	self.targetPos = Vector(0,0,0)
	self.distance = 0
	
	self:SetColor(Color(100,100,100, 255))
	local trail = util.SpriteTrail(self, 0, Color(255,255,255), false, 5, 1, 0.5, 1/(15+1)*0.5, "effects/beam_generic01.vmt")
end

function ENT:PhysicsCollide( colData, collider )
	self:Explode()
end

function ENT:Think()

	local foundEnts = ents.FindInSphere(self:GetPos(), 2 )
	for k, v in pairs( foundEnts ) do
		if (v.Base == "ent_melon_prop_base") then --si es una sandía
			if (v:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0)) then-- si tienen distinto equipo
				self:Explode()
				return true
			end
		end
	end

	local target = self:GetNWEntity("target", nil)
	if (target ~= nil and IsValid(target)) then
		self.targetPos = target:GetPos()
	end
	
	self.distance = self:GetPos():Distance(self.targetPos)
	if (self.targetPos == Vector(0,0,0)) then self:Remove() end
	local targetVec = self.targetPos+self.random*self.distance
	self:SetPos(self:GetPos()+(targetVec-self:GetPos()):GetNormalized()*self.speed)
	self:SetAngles( (targetVec-self:GetPos()):Angle() )
	self:NextThink(CurTime()+0.05)
	if (self.distance < self.speed*1.5) then
		if (self:IsValid()) then
			self:Explode()
		end
	end
	
	return true
end

function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "HelicopterMegaBomb", effectdata )
	sound.Play( "ambient/fire/gascan_ignite1.wav", self:GetPos(), 75, 100, 1 )
	util.BlastDamage( self, self, self:GetPos(), 50, self.damageDeal )
	self:Remove()
end