AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	PropDefaults ( self )

	self.moveType = MOVETYPE_VPHYSICS
	
	self.modelString = "models/hunter/blocks/cube05x105x05.mdl"
	self.materialString = "phoenix_storms/dome"
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	PropSetup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
end

function ENT:PropDeathEffect ( ent )
	MW_PropDefaultDeathEffect ( ent )
end