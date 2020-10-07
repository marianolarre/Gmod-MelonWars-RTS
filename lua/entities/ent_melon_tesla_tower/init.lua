AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_c17/FurnitureBoiler001a.mdl"
	self.speed = 80
	self.spread = 10
	self.damageDeal = 4
	self.maxHP = 100
	self.range = 400
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"
	--self.tracer = "AR2Tracer"
	//self:SetPos(self:GetPos()+Vector(0,0,40))
	self.shotOffset = Vector(0,0,30)
	
	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 0.5
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	MW_Energy_Setup ( self )
	
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:SlowThink ( ent )

	local energyCost = 15
	if (mw_electric_network[self.network].energy >= energyCost) then
		local entities = ents.FindInSphere( ent:GetPos(), ent.range )
		--------------------------------------------------------Disparar
		local targets = 0
		local maxtargets = 3

		local foundEntities = {}
		for k, v in pairs(entities) do
			local tr = util.TraceLine( {
				start = self:GetPos()+self:GetVar("shotOffset", Vector(0,0,0)),
				endpos = v:GetPos()+v:GetVar("shotOffset", Vector(0,0,0)),
				filter = function( foundEnt )
					if ( foundEnt == self ) then return false end
					if ( foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "prop_physics") then--si hay un prop en el medio
						return false
					end
					return true
				end
			})
			if (tostring(tr.Entity) == '[NULL Entity]') then
				if (v.Base == "ent_melon_base" and !ent:SameTeam(v)) then -- si no es un aliado
					table.insert(foundEntities, v)
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
				v.damage = v.damage+self.damageDeal
				local effectdata = EffectData()
				effectdata:SetScale(3000)
				effectdata:SetMagnitude(3000)
				effectdata:SetStart( self:GetPos() + Vector(0,0,45)) 
				effectdata:SetOrigin( v:GetPos() )
				util.Effect( "AirboatGunTracer", effectdata )
				sound.Play( ent.shotSound, ent:GetPos() )
			end
		end
	end
	self:Energy_Set_State()
end

function ENT:Shoot ( ent )
	
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end