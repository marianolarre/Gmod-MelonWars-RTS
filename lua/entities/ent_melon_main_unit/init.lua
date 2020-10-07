AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )
		
	self.slowThinkTimer = 1
	self.nextSlowThink = 0
	self.modelString = "models/hunter/misc/sphere2x2.mdl"
	//self.Angles = Angle(0,0,0)
	self.shotOffset = Vector(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,1))
	self.materialString = "phoenix_storms/gear"
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"
	
	self.canMove = true
	self.canBeSelected = true
	self.speed = 25

	self.maxHP = 500
	self.income = 1
	self.dead = false
	self.range = 300
	self.damageDeal = 7

	self.sphereRadius = 50

	self.buildingDamageMultiplier = 5
	
	self.population = 0

	self.moveForceMultiplier = 2
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.moveType = MOVETYPE_VPHYSICS 
	--local weld = constraint.Weld( self, game.GetWorld(), 0, 0, 0, true , false )

	self:SetNWInt("energy", 0)
	self:SetNWFloat("state", 0) --0 = neutral, 1 = dar, -1 = necesitar
	self:SetNWInt("maxenergy", 100)
	self:SetNWVector("energyPos", Vector(0,0,100))
	
	MW_Setup ( self )
	
	self.zone = ents.Create( "ent_melon_zone" )
	self.zone:SetModel("models/hunter/tubes/circle2x2.mdl")
	self.zone:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self.zone:SetParent(self)
	self.zone:SetPos(self:GetPos()+Vector(0,0,-50))
	self.zone:Spawn()
	self.zone:SetMoveType( MOVETYPE_NONE )
	self.zone:SetModelScale( 4.2, 0 ) //half size
	self.zone:SetMaterial( "models/debug/debugwhite" )
	self.zone:SetNWInt("zoneTeam", mw_melonTeam)
	
	self:DeleteOnRemove( self.zone )

	self.phys:SetMass(1000)
end

function ENT:DeathEffect ( ent )
	if (ent.dead == false) then
		sound.Play( "ambient/explosions/explode_2.wav", ent:GetPos() )
		sound.Play( "ambient/explosions/citadel_end_explosion2.wav", ent:GetPos() )
		for i = 1, 10 do
			timer.Simple(i/4, function()
				local randomVector = Vector(math.random(-100,100), math.random(-100,100), math.random(0,200))
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + randomVector )
				effectdata:SetScale( 100 )
				util.Effect( "Explosion", effectdata )
			end)
		end
		timer.Simple(11/4, function()
			for i = 1, 10 do
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,20*i) )
				effectdata:SetScale( 100 )
				util.Effect( "Explosion", effectdata )
			end
			
			local count = table.Count(debri_props)
			
			for i = 1, count do
				local debris = ents.Create( "prop_physics" )
				debris:SetModel(debri_props[i])
				debris:Ignite( 60 )
				debris:SetPos(ent:GetPos() + Vector(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
				debris:Spawn()
				local debrisPhys = debris:GetPhysicsObject()
				debrisPhys:ApplyForceCenter(Vector(math.random(-10000,10000), math.random(-10000,10000), math.random(10000,70000)))
			end
			
			ent:Remove()
		end)
		------------------------
		sound.Play( "ambient/explosions/explode_2.wav", ent:GetPos() )
		sound.Play( "ambient/explosions/citadel_end_explosion2.wav", ent:GetPos() )
		ent.dead = true
	end
end

function ENT:PhysicsUpdate()
	self:DefaultPhysicsUpdate ()
	self.zone:SetAngles(Angle(0,0,0))
	self.zone:SetPos(self:GetPos()+Vector(0,0,-50))
end

function ENT:SlowThink(ent)
	if (cvars.Bool("mw_admin_cutscene")) then return end
	if (self:GetNWInt("mw_melonTeam", 0) ~= 0) then
		mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] = mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)]+self.income*cvars.Number("mw_admin_base_income")
		for k, v in pairs( player.GetAll() ) do
			if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
				net.Start("MW_TeamCredits")
					net.WriteInt(mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
				net.Send(v)
			end
		end
	end
	MW_UnitDefaultThink ( ent )
end

function ENT:Shoot ( ent )

	local pos = ent:GetPos()+ent.shotOffset
	--------------------------------------------------------Disparar
	if (IsValid(ent.targetEntity)) then
		local targetPos = ent.targetEntity:GetPos()+ent.targetEntity:OBBCenter()
		if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
			if (ent.targetEntity:GetVar("shotOffset") ~= Vector(0,0,0)) then
				targetPos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset")
			end
		end

		ent.targetEntity:TakeDamage( self.damageDeal, self, self )
		/*
		if (ent.targetEntity.damage != nil) then
			ent.targetEntity.damage = ent.targetEntity.damage+self.damageDeal
		end*/

		local effectdata = EffectData()
		effectdata:SetScale(1)
		effectdata:SetMagnitude(1)
		effectdata:SetStart( ent:GetPos()) 
		effectdata:SetOrigin( ent.targetEntity:GetPos() )
		effectdata:SetEntity( ent )
		util.Effect( "ToolTracer", effectdata )
		sound.Play( ent.shotSound, ent:GetPos() )
	end
end

function ENT:_OnTakeDamage( damage )
	self:CreateAlert (self:GetPos(), self:GetNWInt("mw_melonTeam", 0))
	self:SetNWFloat("lastHit", CurTime())
end

function ENT:CreateAlert (pos, _team)
	self:PlayHudSound("ambient/alarms/doomsday_lift_alarm.wav", 0.2, 90, _team)
	local alert = ents.Create( "ent_melon_HUD_alert" )
	alert:SetPos(pos+Vector(0,0,100))
	alert:Spawn()
	alert:SetNWInt("drawTeam", _team)
end