AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self.slowThinkTimer = 20

	self.nextSlowThink = CurTime()+10
	self:SetModel( "models/maxofs2d/balloon_classic.mdl" )
	
	self:SetMaterial("models/shiny")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	if (cvars.Bool("mw_admin_playing")) then
		if (CurTime() > self.nextSlowThink) then
			self.nextSlowThink = CurTime()+self.slowThinkTimer
			self:SlowThink( self )
		end
	end
end

function ENT:SlowThink()
	local drop = ents.Create("ent_melon_present")
	drop:SetPos(self:GetPos()+Vector(0,0,-20))
	drop:Spawn()
	local phys = drop:GetPhysicsObject()
	phys:ApplyForceCenter(Vector(math.random(-15000,15000,0), math.random(-15000, 15000, 0), 0))
	phys:ApplyTorqueCenter(Vector(math.random(-1000,1000,0), math.random(-1000, 1000, 0), math.random(-10,10,0)))
end