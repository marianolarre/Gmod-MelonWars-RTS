AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local melons = {}
local melonsCount = 0
local index = 1

function ENT:Initialize()
	self:SetModel("models/props_c17/gravestone004a.mdl")
	self:SetMaterial("phoenix_storms/stripes")

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:GetPhysicsObject():EnableMotion(false)

	table.Add(melons, ents.FindByClass("ent_melon_*"))

	local propBases = ents.FindByClass("ent_melon_prop_base")
	table.Add(melons, propBases)

	local legalizedProps = ents.FindByClass("prop_physics")
	table.Add(melons, legalizedProps)

	for k, v in pairs(legalizedProps) do
		if (v:GetNWInt("propHP", -1) == -1) then
			table.RemoveByValue(melons, v)
		end
	end

	table.RemoveByValue(melons, self)
	melonsCount = table.Count(melons)
end

function ENT:Think()

	if (melonscount == 0 or index > melonsCount) then
		index = 1
	else
		local curMelon = melons[index]
		if (IsValid(curMelon)) then
			if (curMelon:OBBMins().z+curMelon:GetPos().z < self:GetPos().z) then
				if (curMelon.Base == "ent_melon_prop_base") then
					curMelon:MW_PropDefaultDeathEffect( curMelon )
				elseif (curMelon:GetNWInt("propHP", -1) ~= -1) then
					local effectdata = EffectData()
					effectdata:SetOrigin( curMelon:GetPos() )
					util.Effect( "Explosion", effectdata )
					curMelon:Remove()
				else
					curMelon.damage = 10000000
				end
			end
			index = index + 1
		else
			table.remove( melons, index )
			melonsCount = melonsCount - 1
		end
	end
end

hook.Add("MelonWarsEntitySpawned", "Melon Death Floor subscription", function(ent)
	if (string.StartWith(ent:GetClass(), "ent_melon_")) then
		if (not string.StartWith(ent:GetClass(), "ent_melon_zone")) then
			table.insert(melons, ent)
			melonsCount = melonsCount + 1
		end
	elseif (ent:GetNWInt("propHP", -1) ~= -1) then
		table.insert(melons, ent)
		melonsCount = melonsCount + 1
	end
end)