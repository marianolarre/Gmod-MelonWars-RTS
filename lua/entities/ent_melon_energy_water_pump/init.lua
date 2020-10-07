AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	MW_Energy_Defaults ( self )

	self.modelString = "models/props_buildings/watertower_001c.mdl"
	self.maxHP = 100
	//self.Angles = Angle(0,0,0)
	///local offset = Vector(0,0,50)
	//offset:Rotate(self:GetAngles())
	//self:SetPos(self:GetPos()+offset)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", true)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))

	self.maxWater = 5000
	self.waterGenerated = 0

	MW_Energy_Setup ( self )
end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	if (on) then
		self:SetNWBool("active", false)
		self:SetNWString("message", "Generator Off")
		self:Energy_Add_State()
	else
		self:SetNWBool("active", true)
	end
end

function ENT:Think(ent)
	if(self.spawned) then
		local waterGain = 10
		local energyCost = 10
		if (self.maxWater > self.waterGenerated) then
			if (self:GetNWBool("active", false)) then
				if (self:DrainPower(energyCost)) then
					mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] = mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)]+waterGain
					if (self.value > 0) then
						self.value = self.value-waterGain
						if (self.value < 0) then
							self.value = 0
						end
					end
					self.waterGenerated = self.waterGenerated+waterGain
					for k, v in pairs( player.GetAll() ) do
						if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
							net.Start("MW_TeamCredits")
								net.WriteInt(mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
							net.Send(v)
						end
					end
					self:SetNWString("message", "Generating water ("..self.waterGenerated.."/"..self.maxWater.."w)")
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() + Vector(0,0,55))
					util.Effect( "watersplash", effectdata )
				else
					self:SetNWString("message", "Not enough energy! ("..self.waterGenerated.."/"..self.maxWater.."w)")
				end
			else
				self:SetNWString("message", "Pump Off ("..self.waterGenerated.."/"..self.maxWater.."w)")
			end
			self:Energy_Add_State()
		else
			self:SetNWString("message", "Water depleted. Disassembling...")
			self:SetColor(Color(150,150,150,255))

			self.HP = self.HP-10
			self:SetNWFloat( "health", self.HP )
			if (self.HP <= 0) then
				MW_Die( self )
			end
		end
	end
	self:NextThink( CurTime()+1 )
	return true
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end