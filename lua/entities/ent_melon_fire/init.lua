AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local melons = {}
local melonsCount = 0
local index = 1

function ENT:Initialize()
	self:SetModel("models/hunter/tubes/circle4x4.mdl")
	self:SetMaterial("Models/effects/vol_light001")

	self:Ignite(10, 250)

	timer.Simple(10, function() self:Remove() end)
end