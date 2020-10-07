AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	MW_Energy_Defaults ( self )

	self.modelString = "models/props_combine/combine_booth_med01a.mdl"
	self.maxHP = 1000
	//self.Angles = Angle(0,0,0)
	//local offset = Vector(0,0,20)
	//offset:Rotate(self:GetAngles())
	//self:SetPos(self:GetPos()+offset)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", false)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))
	self.shotOffset = Vector(0,0,30)

	MW_Energy_Setup ( self )

end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	if (on) then
		self:SetNWBool("active", false)
		self:SetNWString("message", "Generator Off")
	else
		self:SetNWBool("active", true)
	end
end

function ENT:Think(ent)
	if(self.spawned) then
		local waterCost = 15
		local energyGain = 100
		if (self:GetNWBool("active", false)) then
			if (mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] >= waterCost or not cvars.Bool("mw_admin_credit_cost")) then
				if (self:GivePower(energyGain)) then
					if (cvars.Bool("mw_admin_credit_cost")) then
						mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] = mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)]-waterCost
						for k, v in pairs( player.GetAll() ) do
							if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
								net.Start("MW_TeamCredits")
									net.WriteInt(mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
								net.Send(v)
							end
						end
					end
					self:SetNWString("message", "Generating energy")
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() + Vector(0,0,55))
					util.Effect( "ManhackSparks", effectdata )
				else
					self:SetNWString("message", "Energy full!")
				end
			end
		else
			self:SetNWString("message", "Generator Off")
		end
	end
	self:Energy_Add_State()
	self:NextThink( CurTime()+1 )
	return true
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			util.BlastDamage( ent, ent, ent:GetPos(), 600, 800 )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "VortDispel", effectdata )

			local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,300))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,300,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(300,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,-300,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-300,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,-150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,-150,0))
				util.Effect( "Explosion", effectdata )
			
			local pos1 = ent:GetPos()// Set worldpos 1. Add to the hitpos the world normal.
			local pos2 = ent:GetPos()+Vector(0,0,-20) // Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()
			
			util.Decal("Scorch",pos1,pos2)
		end
	end)
end