AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_docks/dock01_pole01a_128.mdl"
	self.maxHP = 20
	//self.Angles = Angle(0,0,0)

	self.population = 0

	self.capacity = 0
	self.connectToMachines = true
	self:SetNWVector("energyPos", Vector(0,0,60))

	MW_Energy_Setup ( self )
end

function ENT:Think(ent)
	self:Energy_Set_State()
	self:NextThink( CurTime()+1 )
	return true
end

function ENT:SlowThink(ent)
	--self:CaulculateConnections()
end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end