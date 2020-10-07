AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	MW_Defaults ( self )

	self.modelString = "models/props_phx/misc/soccerball.mdl"
	self.materialString = ""
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	
	self.careForFriendlyFire = false
	
	self.slowThinkTimer = 1
	
	self.population = 2

	self.sphereRadius = 9
	
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.range = 80
	self.speed = 115
	self.damageDeal = 80
	self.maxHP = 15

	self.meleeAi = true

	self.dootChance = 0

	MW_Setup ( self )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r*1.3, self:GetColor().g*1.3, self:GetColor().b*1.3, 255))
end

function ENT:SkinMaterial()
	self:SetMaterial("")
end

function ENT:DeathEffect( ent )
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			util.BlastDamage( ent, ent, ent:GetPos(), 80, ent.damageDeal )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "Explosion", effectdata )
			
			local pos1 = ent:GetPos()// Set worldpos 1. Add to the hitpos the world normal.
			local pos2 = ent:GetPos()+Vector(0,0,-20) // Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()
			
			util.Decal("Scorch",pos1,pos2)
		end
	end)
end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
	--[[if (ent.canMove) then
		MW_UnitDefaultThink ( ent )
	else 
		local pos = ent:GetPos()
		if (ent.targetEntity == nil) then
			----------------------------------------------------------------------Buscar target
			local foundEnts = ents.FindInSphere(pos, ent.range )
			for k, v in RandomPairs( foundEnts ) do
				if (v.Base == "ent_melon_base") then
					if (v:GetNWInt("mw_melonTeam", -1) ~= ent:GetNWInt("mw_melonTeam", -1)) then
						ent.targetEntity = v
						ent:Shoot(ent)
					end
				end
			end
		end 
	end]]
end

function ENT:PostEntityPaste( ply, ent, createdEntities )
	self:SetPos(self:GetPos()+Vector(0,0,1.2))
end

function ENT:Welded (ent, trace)
	ent:SetModel("models/props_c17/clock01.mdl")
	ent:SetPos(ent:GetPos()+Vector(0,0,0))
	ent.canMove = false
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	ent.maxHP = 10
	ent.HP = 10
	ent.population = 1
	//MW_UpdatePopulation(-1, mw_melonTeam)
	ent.range = 100
	ent.materialString = "Models/effects/comball_sphere"
	--[[for i = 1, 4 do
		timer.Simple( 1+i*0.05, function()
			if (IsValid(ent)) then
				ent:SetPos(ent:GetPos()+Vector(0,0,-0.3))
			end
		end	)
	end]]
	timer.Simple( 1.3, function()
		if (ent:IsValid()) then
			ent:SetMaterial(ent.materialString)
			ent:SetColor(Color(255, 255, 255, 255))
			ent:DrawShadow( false )
			local effectdata = EffectData()
			effectdata:SetStart( ent:GetPos())
			util.Effect( "ImpactJeep", effectdata )
			ent.targetable = false
		end
	end )
	local weld = constraint.Weld( self, game.GetWorld(), 0, trace.PhysicsBone, 0, true , false )
end

function ENT:OnTakeDamage( damage )
	if (self.canMove) then
		if ((damage:GetAttacker():GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not damage:GetAttacker():GetVar('careForFriendlyFire')) and not damage:GetAttacker():IsPlayer()) then 
			if (damage:GetAttacker():GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				self.HP = self.HP - damage:GetDamage()/10
			else
				self.HP = self.HP - damage:GetDamage()
			end
			self:SetNWFloat( "health", self.HP )
			if (self.HP <= 0) then
				MW_Die (self)
			end
		end
	else
		--Negate damage
	end
end

function ENT:Shoot ( ent, forcedTargetPos)
	sound.Play("buttons/button8.wav", ent:GetPos())
	ent.forceExplode = (forcedTargetPos != nil)
	timer.Simple( 0.3, function()
		if (!ent.forceExplode and !IsValid(ent.targetEntity)) then
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime()+0.1
			return false
		else
			if (ent.forceExplode or tostring( ent.targetEntity ) ~= "[NULL Entity]") then
			--util.BlastDamage( ent, ent, ent:GetPos(), 100, ent.damageDeal )
			--local effectdata = EffectData()
			--effectdata:SetOrigin( ent:GetPos() )
			--util.Effect( "Explosion", effectdata )
			--ent:Remove()
				ent:SetPos(ent:GetPos()+Vector(0,0,3))
				MW_Die ( ent )
			end
		end
	end )
end