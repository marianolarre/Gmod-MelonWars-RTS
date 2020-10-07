AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_docks/dock01_pole01a_256.mdl"
	self.maxHP = 50
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,100))

	self.population = 0

	self.capacity = 0
	self.connectToMachines = false
	self.connectToRelaysOnly = true
	self.connectionRange = 1000

	self:SetNWVector("energyPos", Vector(0,0,125))

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