AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/hunter/misc/sphere1x1.mdl"
	self.materialString = "phoenix_storms/dome"
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	
	self.careForFriendlyFire = false
	
	self.slowThinkTimer = 1
	
	self.population = 4

	self.sphereRadius = 20
	
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.range = 80
	self.speed = 60
	self.damageDeal = 250
	self.maxHP = 250

	MW_Setup ( self )

	--self:SetColor(Color(self:GetColor().r/2, self:GetColor().g/2, self:GetColor().b/2, 255))
	
	self.effect = ents.Create( "prop_physics" )
		self.effect:SetModel("models/hunter/misc/sphere1x1.mdl")
		self.effect:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		
		self.effect:SetPos(self:GetPos())
		self.effect:Spawn()
		self.effect:SetModelScale( 1.2, 0 )
		self.effect:SetMaterial( "models/alyx/emptool_glow" )
		--self.effect:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.effect:SetColor(Color(self:GetColor().r+100, self:GetColor().g+100, self:GetColor().b+100, 255))
		--self.effect:SetColor(self:GetColor())
		self.effect:GetPhysicsObject():SetMass(0.01)
		--self.effect:SetColor(Color(255,255,255,255))
		
		self:DeleteOnRemove( self.effect )
		
		self.effect:SetParent( self, -1 )
	//local weld = constraint.Weld( self, self.effect, 0, 0, 0, true , false )
	
	for k, v in pairs( player.GetAll() ) do
		sound.Play( "ambient/alarms/train_horn_distant1.wav", v:GetPos(), 60, 75, 1)
		v:PrintMessage( HUD_PRINTCENTER, "NUKE detected!" )
		v:PrintMessage( HUD_PRINTTALK, "/////////////////// NUKE detected! ///////////////////" )
	end
end

function ENT:DeathEffect( ent )
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			util.BlastDamage( ent, ent, ent:GetPos(), 80, 100 )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "Explosion", effectdata )
			sound.Play( "ambient/explosions/explode_5.wav", ent:GetPos(), 110, 75, 1)
			ent:Remove()
		end
	end)
end

function ENT:SlowThink ( ent )
	if (ent.canShoot) then
		local pos = ent:GetPos()
		----------------------------------------------------------------------Buscar target
		local foundEnts = ents.FindInSphere(pos, ent.range )
		for k, v in RandomPairs( foundEnts ) do
			--local isConstr = mw_melonTeam
			--if (v:GetClass() == "prop_physics") then
			--	isConstr = v:GetVar('mw_melonTeam')
			--end
			if (v.Base == "ent_melon_prop_base") then --si es una pared
				if (v:GetNWInt("mw_melonTeam", 0) ~= ent:GetNWInt("mw_melonTeam", 0)) then-- si tienen distinto equipo
					----------------------------------------------------------Encontró target
					ent.targetEntity = v
				end
			end
		end
		
		if (IsValid(ent.targetEntity)) then
			local distance = ent.targetEntity:GetPos():Distance(ent:GetPos())
			if (distance < ent.range and distance > ent.minRange) then
				if (ent.targetEntity:GetNWInt("mw_melonTeam", 0) ~= ent:GetNWInt("mw_melonTeam", 0)) then
					ent:Shoot( ent )
				end
			end
		end
	end
	
	if (ent:GetVelocity():Length() < 30 and ent.moving == false) then
		--ent.phys:SetAngles( ent.Angles )
		ent.phys:Sleep()
	end
end

function ENT:Shoot ( ent, forcedTargetPos )
	for k, v in pairs( player.GetAll() ) do
		sound.Play("ambient/alarms/razortrain_horn1.wav", v:GetPos(), 70, 90, 1)
	end
	ent.forceExplode = (forcedTargetPos != nil)
	timer.Simple( 1.5, function()
		if (ent.forceExplode or IsValid(ent.targetEntity)) then
		timer.Simple( 0.02, function()
			if (ent:IsValid()) then
				util.BlastDamage( ent, ent, ent:GetPos(), 500, ent.damageDeal )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() )
				util.Effect( "Explosion", effectdata )
				sound.Play( "ambient/explosions/explode_5.wav", ent:GetPos(), 110, 75, 1)
				
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,150))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,-150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(110,110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-110,110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(110,-110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-110,-110,0))
				util.Effect( "Explosion", effectdata )
			end
		end)
		--util.BlastDamage( ent, ent, ent:GetPos(), 100, ent.damageDeal )
		--local effectdata = EffectData()
		--effectdata:SetOrigin( ent:GetPos() )
		--util.Effect( "Explosion", effectdata )
		--ent:Remove()
			MW_Die ( ent )
		end
	end )
end