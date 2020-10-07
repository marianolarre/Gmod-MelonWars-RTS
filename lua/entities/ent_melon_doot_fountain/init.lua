AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_c17/gravestone002a.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	local vPoint = self:GetPos()+Vector(0,0,35)
	SpawnUnitAtPos("ent_melon_doot", 0, vPoint, Angle(0,0,0), 0, 0, 0, false, nil, nil)
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "AntlionGib", effectdata )
	sound.Play("npc/zombie/zombie_pain4.wav", vPoint, 75, 240)
	self:NextThink( CurTime()+8/*10*/ )
	return true
end