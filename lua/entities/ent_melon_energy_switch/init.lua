AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_trainstation/trashcan_indoor001b.mdl"
	self.maxHP = 20
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos() + Vector(0,0,16))

	self.population = 0

	self.connectToMachines = true

	self.open = true
	self.allowConnection = self.open
	self.lastSwitch = CurTime()
	self:SetNWBool("open", self.open)
	if (self.open) then
		self:SetNWString("message", "Open")
	else
		self:SetNWString("message", "Closed")
	end

	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,10))

	MW_Energy_Setup ( self )
end

function ENT:Actuate ()
	if (self.lastSwitch < CurTime()-1) then
		self.open = !self.open
		self:SetNWBool("open", self.open)
		if (self.open) then
			self:SetNWString("message", "Open")
			self:Energy_Add_State()
			MW_CalculateConnections(self, self.connectToMachines)
		else
			self:SetNWString("message", "Closed")
			for k, v in pairs(self.connections) do
				table.RemoveByValue(v.connections, self)
			end
			MW_Energy_Network_Remove_Element(self)
		end
		self.allowConnections = self.open
		self.lastSwitch = CurTime()
	end
end

function ENT:Think(ent)
	if (self.open) then
		self:SetNWString("message", "Open")
		self:Energy_Add_State()
	else
		self:SetNWString("message", "Closed")
	end
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