AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	//self:SetPos(self:GetPos()+Vector(0,0,-5))
	
	MW_Defaults ( self )

	self.modelString = "models/props_phx/construct/metal_plate2x2.mdl"
	self.materialString = "phoenix_storms/metalfloor_2-3"
	self.moveType = MOVETYPE_NONE
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,0))
	self.canMove = false
	self.canShoot = false
	self.maxHP = 100
	
	self.active = true
	
	self.slowThinkTimer = 0.5
	
	self.population = 0
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self.melons = {}

	self:SetNWEntity("transport", nil)

	MW_Setup ( self )
end

function ENT:SlowThink(ent)
	local foundTransports = ents.FindByClass( "ent_melon_unit_transport" )
	local range = 300
	local closest = nil
	local distSqr = range*range
	local found = false
	for k, v in pairs( foundTransports ) do
		if (v:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", -1)) then
			local thisDistSqr = v:GetPos():DistToSqr(self:GetPos())
			if (thisDistSqr < distSqr) then
				if (v.canEatUnits and 1 <= v:GetNWInt("maxunits", 0) - v:GetNWInt("count", 0)) then
					closest = v
					distSqr = thisDistSqr
					found = true
				end
			end
		end
	end
	self:SetNWBool("hasTransport", found)
	
	if (found) then
		self:SetNWEntity("transport", closest)
		local foundEnts = ents.FindInSphere( ent:GetPos()+Vector(0,0,0), 50 )
		for k, v in pairs( foundEnts ) do
			if (v.Base == "ent_melon_base") then
				if (v.canMove) then
					if (closest.canEatUnits and v.population <= closest:GetNWInt("maxunits", 0) - closest:GetNWInt("count", 0)) then
						local phys = v:GetPhysicsObject()
						if (IsValid(phys)) then
							local effectdata = EffectData()
							effectdata:SetScale(1)
							effectdata:SetMagnitude(1)
							effectdata:SetStart( v:GetPos()) 
							effectdata:SetOrigin( closest:GetPos() )
							util.Effect( "ToolTracer", effectdata )
							sound.Play( "buttons/blip1.wav", self:GetPos() )
							closest:AbsorbUnit(v)			
						end
					end
				end
			end
		end
	end
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end