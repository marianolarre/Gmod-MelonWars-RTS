AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:PhysicsInitSphere( 5, "default" )
	self.rotation = AngleRand():Forward()
	self:GetPhysicsObject():SetDamping(0,0)
	local time = 3.7
	self:Ignite( time, 0.1 )
	timer.Simple( time, function()
		if (self:IsValid()) then
			util.BlastDamage( self, self, self:GetPos(), 30, 75 )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "Explosion", effectdata )
			self:Remove()
		end
	end	)
end

function ENT:PhysicsUpdate()
	local phys = self:GetPhysicsObject()
	phys:ApplyTorqueCenter( self.rotation*50 )
	phys:ApplyForceCenter(Vector(0,0,5.6)*phys:GetMass())
end