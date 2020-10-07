AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	MW_Defaults ( self )

	self.unit = 10
	self.modelString = "models/props_lab/teleportframe.mdl"
	self.maxHP = 250
	//self.Angles = Angle(0,0,0)
	--self:SetPos(self:GetPos()+Vector(0,0,10))

	self:BarrackInitialize()
	self.population = 1
	self:SetNWInt("maxunits", 1)

	MW_Setup ( self )
end

function ENT:Think(ent)

	self:SetNWInt("count", 0)

	self:BarrackSlowThink()

	self:NextThink(CurTime()+0.2)
	return true
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end