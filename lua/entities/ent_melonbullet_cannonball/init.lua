AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInitSphere( 5, "default" )
	self.rotation = AngleRand():Forward()
	self:GetPhysicsObject():SetDamping(0,0)
	local time = 5
	self:Ignite( time, 0.1 )
	self.exploded = false

	util.SpriteTrail( self, 0, Color(255, 200, 50), true, 30, 0, 0.5, 0.05, "trails/smoke" )
end

function ENT:PhysicsUpdate()
	self:GetPhysicsObject():ApplyTorqueCenter( self.rotation*50 )
end

function ENT:PhysicsCollide( colData, collider )
	local vel = self:GetVelocity():Length()
	if (self.exploded == false) then
		local other = colData.HitEntity
		local otherhealth = other:GetNWFloat("health", 0)
		if (otherhealth != 0) then
			self.exploded = true

			util.BlastDamage( self, self, self:GetPos(), 50, 50 )

			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "HelicopterMegaBomb", effectdata )
			local newHealth = otherhealth-100
			other:SetNWFloat("health", newHealth)
			if (other:GetNWFloat("health", 1) <= 0) then
				MW_Die(other)
			else
				if (other:GetClass() == "ent_melon_wall") then
					if (newHealth < 100) then
						constraint.RemoveConstraints( other, "Weld" )
					end
				end
			end
		end
		self:GetPhysicsObject():SetVelocity(Vector(0,0,-1000))
		timer.Simple( 1, function()
			if (self:IsValid()) then
				util.BlastDamage( self, self, self:GetPos(), 70, 50 )
				local effectdata = EffectData()
				effectdata:SetOrigin( self:GetPos() )
				util.Effect( "Explosion", effectdata )
				self:Remove()
			end
		end	)
	end
end