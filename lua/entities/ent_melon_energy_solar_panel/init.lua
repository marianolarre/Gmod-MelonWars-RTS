AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_combine/weaponstripper.mdl"
	self.maxHP = 20
	//self.Angles = Angle(-90,0,180)
	//local offset = Vector(0,0,0)
	//offset:Rotate(self:GetAngles())
	//self:SetPos(self:GetPos()+offset)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.moveType = MOVETYPE_NONE

	self.canMove = false

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,62.5))

	self.shotOffset = Vector(0,0,1)

	self.history = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	self.historyTotal = 25

	MW_Energy_Setup ( self )

	self:EstimateEfficiency()
end

function ENT:EstimateEfficiency()
	local angles = self:GetAngles()
	for i=0, 25 do
		local offset = angles:Right()*math.random(-60,60)+self:GetAngles():Up()*math.random(0,120)
		local tr = util.TraceLine( {
			start = self:GetPos() + offset,
			endpos = self:GetPos() + offset + Vector(0, 0, 10000),
			filter = function( ent ) if ( ent:GetClass() != "player" ) and ent != self then return true end end
		} )
		local freeSky = tr.HitSky or not tr.Hit
		if (freeSky) then
			table.insert(self.history, 1)
			self.historyTotal = self.historyTotal+1
		else
			table.insert(self.history, 0)
		end

		self.historyTotal = self.historyTotal-self.history[1]
		table.remove(self.history, 1)
	end
end

function ENT:Think(ent)
	if(self.spawned) then
		local angles = self:GetAngles()
		local offset = angles:Right()*math.random(-60,60)+self:GetAngles():Up()*math.random(0,120)
		local tr = util.TraceLine( {
			start = self:GetPos() + offset,
			endpos = self:GetPos() + offset + Vector(0, 0, 10000),
			filter = function( ent ) if ( ent:GetClass() != "player" ) and ent != self then return true end end
		} )
		local freeSky = tr.HitSky or not tr.Hit
		if (freeSky) then
			local can = self:GivePower(1)
			local efficiencyText = self.historyTotal*4
			table.insert(self.history, 1)
			self.historyTotal = self.historyTotal+1
			if (can) then
				self:SetNWString("message", "Generating energy\nEfficiency:"..efficiencyText.."%")
			else
				self:SetNWString("message", "Energy full!\nEfficiency:"..efficiencyText.."%")
			end
		else
			local efficiencyText = self.historyTotal*4
			self:SetNWString("message", "Sky blocked\nEfficiency:"..efficiencyText.."%")
			table.insert(self.history, 0)
		end
	end

	self.historyTotal = self.historyTotal-self.history[1]
	table.remove(self.history, 1)

	self:Energy_Add_State()
	self:NextThink( CurTime()+2 )
	return true
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end