AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_c17/substation_transformer01d.mdl"

	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 5

	self.canMove = false
	self.canShoot = false

	self.range = 250
	
	self.population = 1
	
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"

	self.connection = nil
	self.careForFriendlyFire = false
	self.careForWalls = false

	//self:SetPos(self:GetPos()+Vector(0,0,-5))
	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,15)

	MW_Energy_Setup ( self )
end

function ENT:ModifyColor()
	//self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )
	local chargeAmount = 100

	if (mw_electric_network[self.network].energy >= chargeAmount) then
		local entities = ents.FindInSphere( ent:GetPos(), ent.range )
		--------------------------------------------------------Disparar
		local targets = 0
		local maxtargets = 1

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
						if (v:GetNWInt("mw_charge", -1) > -1) then
							if (v:GetNWInt("mw_charge", 0) < v:GetNWInt("maxCharge", 0)) then
								table.insert(foundEntities, v)
							end
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
			if (self:DrainPower(chargeAmount)) then
				ent.targetEntity = v
				ent:Shoot(ent)
			end
		end
	end

	self:Energy_Set_State()
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
			effectdata:SetScale(3000)
			effectdata:SetMagnitude(3000)
			effectdata:SetStart( self:GetPos() + Vector(0,0,45)) 
			effectdata:SetOrigin( targetPos )
			util.Effect( "AirboatGunTracer", effectdata )
			sound.Play( ent.shotSound, ent:GetPos() )

			local chargeAmount = 100
			ent.targetEntity:SetNWInt("mw_charge",ent.targetEntity:GetNWInt("mw_charge",0)+chargeAmount)
			ent.fired = true
			if (ent.targetEntity:GetNWInt("mw_charge",0) >= ent.targetEntity:GetNWInt("maxCharge",0)) then
				ent.targetEntity:SetNWInt("mw_charge",ent.targetEntity:GetNWInt("maxCharge",0))
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