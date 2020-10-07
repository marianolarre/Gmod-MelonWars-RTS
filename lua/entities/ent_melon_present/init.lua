AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local present_possibilities = {
	"ent_melon_marine",
	"ent_melon_marine",
	"ent_melon_marine",
	"ent_melon_marine",
	"ent_melon_medic",
	"ent_melon_medic",
	"ent_melon_jetpack",
	"ent_melon_jetpack",
	"ent_melon_bomb",
	"ent_melon_bomb",
	"ent_melon_gunner",
	"ent_melon_gunner",
	"ent_melon_missiles",
	"ent_melon_missiles",
	"ent_melon_sniper",
	"ent_melon_sniper",
	"ent_melon_hotshot",
	"ent_melon_hotshot",
	"ent_melon_mortar",
	"ent_melon_cannon",
	"ent_melon_doot",
	"ent_melon_nuke"
}

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )

	local time = 60

	self:SetNWFloat("expiration", CurTime()+time)

	timer.Simple(time, function()
		if (IsValid(self)) then
			self:Remove()
		end
	end)
end

function ENT:PhysicsCollide( colData, collider )
	local _team = colData.HitEntity.mw_melonTeam
	if (colData.HitEntity.Base == "ent_melon_base") then
		if (_team != nil) then
			self:Open(_team)
		end
	end
end

function ENT:Open(_team)
	sound.Play( "garrysmod/balloon_pop_cute.wav", self:GetPos(), 75, 100, 1 )
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	for i=0, 5 do
		util.Effect( "balloon_pop", effectdata )
	end

	local randomclass = present_possibilities[ math.random( #present_possibilities ) ]

	local unit = SpawnUnitAtPos (randomclass, 0, self:GetPos(), Angle(0,0,0), 0, 0, _team, false, nil, nil)

	local time = 180

	unit:SetNWInt("expiration", CurTime()+time)
	timer.Simple(time, function()
		if (IsValid(unit)) then
			unit:Remove()
		end
	end)

	self:Remove()
end