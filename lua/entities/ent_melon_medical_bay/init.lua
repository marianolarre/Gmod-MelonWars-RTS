AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_phx/wheels/747wheel.mdl"

	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 5

	self.canMove = false
	self.canShoot = false

	self.range = 750
	
	self.population = 1
	
	self.shotSound = "items/medshot4.wav"

	self.connection = nil
	self.careForFriendlyFire = false
	self.careForWalls = false

	//self:SetPos(self:GetPos()+Vector(0,0,-5))
	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,15)

	MW_Energy_Setup ( self )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )

	if (ent.HP < ent.maxHP) then
		ent.HP = ent.HP+1
		if (ent.HP > ent.maxHP) then
			ent.HP = ent.maxHP
		end
		ent:SetNWFloat( "health", ent.HP )
	end

	local energyCost = 10

	if (mw_electric_network[self.network].energy >= energyCost) then
		local entities = ents.FindInSphere( ent:GetPos(), ent.range )
		--------------------------------------------------------Disparar
		local targets = 0
		local maxtargets = 10

		local foundEntities = {}
		for k, v in pairs(entities) do
			local tr = util.TraceLine( {
				start = self:GetPos()+self:GetVar("shotOffset", Vector(0,0,0)),
				endpos = v:GetPos()+v:GetVar("shotOffset", Vector(0,0,0)),
				filter = function( foundEnt )
					if ( foundEnt == self) then--si hay un prop en el medio
						return false
					end
					if ( foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "prop_physics") then--si hay un prop en el medio
						return false
					end
					return true
				end
			})
			if (tostring(tr.Entity) == '[NULL Entity]') then
				if (v.Base == "ent_melon_base" and (ent:SameTeam(v) or v:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0))) then -- si no es un aliado
					if (v.spawned) then
						if (v:GetVar("HP") < v:GetVar("maxHP")) then
							table.insert(foundEntities, v)
						end
					end
				end
			end
		end

		local closestEntities = {}
		for i=1, maxtargets do
			local closestDistance = 0
			local closestEntity = nil
			for k, v in pairs(foundEntities) do
				if (closestEntity == nil or ent:GetPos():DistToSqr( v:GetPos() ) < closestDistance) then
					closestEntity = v
					closestDistance = ent:GetPos():DistToSqr( v:GetPos() )
				end
			end
			table.RemoveByValue(foundEntities, closestEntity)
			table.insert(closestEntities, closestEntity)
		end

		for k, v in pairs(closestEntities) do
			if (self:DrainPower(energyCost)) then
			----------------------------------------------------------Encontró target
				--[[v.damage = v.damage+self.damageDeal
				local effectdata = EffectData()
				effectdata:SetScale(1)
				effectdata:SetMagnitude(1)
				effectdata:SetStart( ent:GetPos() + Vector(0,0,45)) 
				effectdata:SetOrigin( v:GetPos() )
				util.Effect( "ToolTracer", effectdata )
				sound.Play( ent.shotSound, ent:GetPos() )
				]]
				ent.targetEntity = v
				ent:Shoot(ent)
			end
		end
	end

	self:Energy_Set_State()

	--[[local energy = math.Round(self:GetNWInt("energy", 0))
	local max = self:GetNWInt("maxenergy", 0)
	self:SetNWString("message", "Energy: "..energy.." / "..max)]]

	--[[
	local pos = ent:GetPos()
	if (ent.targetEntity == nil) then
		----------------------------------------------------------------------Buscar target
		local foundEnts = ents.FindInSphere(pos, ent.range )
		for k, v in RandomPairs( foundEnts ) do
			if (v.Base == "ent_melon_base") then
				if (v:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(v)) then
					if(v ~= ent) then
						if (v.spawned) then
							local tr = util.TraceLine( {
							start = pos,
							endpos = v:GetPos(),
							filter = function( foundEnt )
								if ( foundEnt:GetClass() == "prop_physics" ) then
									return true
								end
							end
							})
							if (tostring(tr.Entity) == '[NULL Entity]') then
							----------------------------------------------------------Encontró target
								if (v:GetVar("HP") < v:GetVar("maxHP")) then
									ent.targetEntity = v
								end
							end
						end
					end
				end
			end
		end
	end
	
	--if (IsValid(ent.forcedTargetEntity)) then
	--	ent.targetEntity = ent.forcedTargetEntity
	--else
	--	ent.forcedTargetEntity = nil
	--end
	
	if (ent.targetEntity ~= nil) then
		----------------------------------------------------------------------Perder target
		----------------------------------------por que no existe
		if (!IsValid(ent.targetEntity)) then
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime()+0.1
			return false
		end
		----------------------------------------por que está lejos
		if (IsValid(ent.targetEntity) and ent.targetEntity:GetPos():Distance(pos) > ent.range) then
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime()+0.1
			return false
		end
		----------------------------------------por que hay algo en el medio
		local tr = util.TraceLine( {
		start = pos,
		endpos = ent.targetEntity:GetPos(),
		filter = function( foundEntity ) if ( foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity  and !string.StartWith( ent.targetEntity:GetClass(), "ent_melonbullet_" )) then return true end end
		})
		if (tostring(tr.Entity) ~= '[NULL Entity]') then
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime()+0.1
			return false
		end
		ent:Shoot( ent )
	end]]
end

function ENT:Shoot ( ent )
	--------------------------------------------------------Disparar
	if (ent.targetEntity == ent) then ent.targetEntity = nil end
	if (IsValid(ent.targetEntity)) then
		if (ent.targetEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(ent.targetEntity)) then
			local pos = ent:GetPos()+ent.shotOffset
			local targetPos = ent.targetEntity:GetPos()
			if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
				targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
			end
			//ent:FireBullets(bullet)
			local effectdata = EffectData()
			effectdata:SetOrigin( targetPos + Vector(0,0,10) )
			util.Effect( "inflator_magic", effectdata )
			util.Effect( "inflator_magic", effectdata )
			util.Effect( "inflator_magic", effectdata )
			util.Effect( "inflator_magic", effectdata )
			util.Effect( "inflator_magic", effectdata )
			effectdata:SetOrigin( pos + Vector(0,0,10) )
			util.Effect( "inflator_magic", effectdata )
			sound.Play( ent.shotSound, pos )
			local heal = ent.targetEntity:GetVar("HP")+math.min(ent.damageDeal, ent.targetEntity:GetVar("maxHP")-ent.targetEntity:GetVar("HP"))
			ent.targetEntity:SetVar("HP", heal)
			ent.targetEntity:SetNWFloat("health", heal)
			ent.fired = true
			if (ent.targetEntity:GetVar("HP") == ent.targetEntity:GetVar("maxHP")) then
				ent.targetEntity = nil
			end
		else
			ent.targetentity = nil
		end
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end