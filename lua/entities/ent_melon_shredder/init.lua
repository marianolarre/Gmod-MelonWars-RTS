AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_c17/TrapPropeller_Blade.mdl"
	//self.Angles = Angle(0,0,0)
	self.canMove = false
	self.canBeSelected = false
	self.canShoot = false
	self.maxHP = 20
	self.moveType = MOVETYPE_VPHYSICS
	
	self.damageDeal = 10
	self.slowThinkTimer = 0.1
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self.careForFriendlyFire = false
	
	self.population = 0	
	//self:SetPos(self:GetPos()+Vector(0,0,0))
	
	self.melons = {}
	MW_Setup ( self )
	
	local LPos1 = Vector(0,0,0)
	local LVector = Vector(0,0,1)

	timer.Simple(0.2, function()
		constraint.RemoveAll( self )
		local axis = constraint.Axis(self, game.GetWorld(), 0, 0, LPos1, LPos1, 0, 0, 0, 0, LVector, false)
		self:GetPhysicsObject():EnableCollisions( false )
		self:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
	end)
end

function ENT:SlowThink(ent)
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceOffset(Vector(-5000,0,0), Vector(0, 100, 0))
	phys:ApplyForceOffset(Vector(5000,0,0), Vector(0, -100, 0))
	local foundEnts = ents.FindInSphere( ent:GetPos() , 60 )
	for k, v in pairs( foundEnts ) do
		if (v:GetClass() ~= "ent_melon_shredder") then
			if (v.Base == "ent_melon_base") then
				if (v:GetNWFloat("health", 100) <= self.damageDeal) then
					local gain = v:GetVar("value")*0.9
					if (v.spawned and v:GetClass() == "ent_melon_voidling") then
						gain = v:GetVar("value")+1
					end
					--if (v:GetVar("mw_melonTeam") ~= self:GetNWInt("mw_melonTeam", 0)) then
					--	gain = math.max(15, gain)
					--end
					mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] = mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)]+gain
					for k, v in pairs( player.GetAll() ) do
						if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
							net.Start("MW_TeamCredits")
								net.WriteInt(mw_teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
							net.Send(v)
						end
					end
				end
			
				v.damage = v.damage+self.damageDeal
				//v:SetNWFloat("health", v:GetNWFloat("health", 1)-self.damageDeal)
				v.gotHit = true
				/*if (v:GetNWFloat("health", 1) <= 0) then
					MW_Die(v)
				end*/
			end
		end
	end
end

--[[
function ENT:StartTouch( entity )
	if (entity.Base == "ent_melon_base") then
		if (entity:GetVar("HP") <= self.damageDeal) then
			local gain = entity:GetVar("value")
			if (entity:GetVar("mw_melonTeam") ~= self.mw_melonTeam) then
				gain = math.max(15, gain)
			end
			mw_teamCredits[self.mw_melonTeam] = mw_teamCredits[self.mw_melonTeam]+gain
			for k, v in pairs( player.GetAll() ) do
				if (v:GetInfo("mw_team") == tostring(self.mw_melonTeam)) then
					net.Start("MW_TeamCredits")
						net.WriteInt(mw_teamCredits[self.mw_melonTeam] ,32)
					net.Send(v)
				end
			end
		end
	
		entity:TakeDamage( self.damageDeal, self, self )
	end
end
]]

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end