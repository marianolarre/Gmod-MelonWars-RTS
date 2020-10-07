AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/props_phx/ww2bomb.mdl")
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	
	self.careForFriendlyFire = false

	self.speed = 18
	self.damageDeal = 100
	self.maxHP = 20
	self.random = Vector(math.random()/2-1/4, math.random()/2-1/4, math.random()/6+0.1)
	
	self.targetPos = Vector(0,0,0)
	self.distance = 0
	
	self:SetColor(Color(100,100,100, 255))
	local trail = util.SpriteTrail(self, 0, Color(255,255,255), false, 10, 1, 2, 1/(15+1)*0.5, "effects/beam_generic01.vmt")
end

/*function ENT:PhysicsCollide( colData, collider )
	self:Explode()
end*/

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
	if (self.targetPos == Vector(0,0,0) and target ~= nil and IsValid(target)) then
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
			self:SetPos(self.targetPos)
			self:Explode()
		end
	end
	
	return true
end

function ENT:Explode()
	util.BlastDamage( self, self, self:GetPos(), 60, self.damageDeal )

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", effectdata )
	local target = self:GetNWEntity("target", nil)
	/*if (target ~= nil and IsValid(target)) then
		target.damage = 100
	end*/
	for k, v in pairs( player.GetAll() ) do
		sound.Play( "ambient/explosions/explode_3.wav", v:GetPos(), 75, 100, 1 )
	end

	self:Remove()
end