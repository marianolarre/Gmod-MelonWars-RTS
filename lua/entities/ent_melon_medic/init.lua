AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_junk/watermelon01.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	
	self.damageDeal = 4
	self.maxHP = 30

	self.speed = 90

	self.sphereRadius = 7
	
	self.population = 1

	self.captureSpeed = 1
	
	self.shotSound = "items/medshot4.wav"

	MW_Setup ( self )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )
	local healed = false
	if (ent.canShoot) then
		local pos = ent:GetPos()
		if (ent.targetEntity == nil) then
			----------------------------------------------------------------------Buscar target
			local foundEnts = ents.FindInSphere(pos, ent.range )
			for k, v in RandomPairs( foundEnts ) do
				if (v.Base == "ent_melon_base") then
					if (v:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(v)) then
						if(v:GetClass() ~= ent:GetClass()) then
							if (not string.StartWith(v:GetClass(), "ent_melon_main_building")) then
								if (v.spawned) then
									if (v.canMove) then
										local tr = util.TraceLine( {
										start = pos,
										endpos = v:GetPos(),
										filter = function( foundEnt )
											if ( foundEnt:GetClass() == "prop_physics" ) then
												return true
											end
										end
										})
										if (tostring(tr.Entity) == '[NULL Entity]') then
										----------------------------------------------------------Encontró target
											if (v:GetVar("HP") < v:GetVar("maxHP")) then
												ent.targetEntity = v
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		--if (IsValid(ent.forcedTargetEntity)) then
		--	ent.targetEntity = ent.forcedTargetEntity
		--else
		--	ent.forcedTargetEntity = nil
		--end
		
		if (ent.targetEntity ~= nil) then
			----------------------------------------------------------------------Perder target
			----------------------------------------por que no existe
			if (!IsValid(ent.targetEntity)) then
				ent.targetEntity = nil
				ent.nextSlowThink = CurTime()+0.1
				return false
			end
			----------------------------------------por que está lejos
			if (IsValid(ent.targetEntity) and ent.targetEntity:GetPos():Distance(pos) > ent.range) then
				ent.targetEntity = nil
				ent.nextSlowThink = CurTime()+0.1
				return false
			end
			----------------------------------------por que hay algo en el medio
			local tr = util.TraceLine( {
			start = pos,
			endpos = ent.targetEntity:GetPos(),
			filter = function( foundEntity ) if ( foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity and !string.StartWith( ent.targetEntity:GetClass(), "ent_melon_main_building") and !string.StartWith( ent.targetEntity:GetClass(), "ent_melonbullet_" )) then return true end end
			})
			if (tostring(tr.Entity) ~= '[NULL Entity]') then
				ent.targetEntity = nil
				ent.nextSlowThink = CurTime()+0.1
				return false
			end

			healed = ent:Shoot( ent )
		end
	end
	if (not healed) then
		if (ent.HP < ent.maxHP) then // SELF HEAL
			ent.HP = ent.HP+1
			if (ent.HP > ent.maxHP) then
				ent.HP = ent.maxHP
			end
			ent:SetNWFloat( "health", ent.HP )
		end
	end
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		--------------------------------------------------------Disparar
		if (forcedTargetPos != nil) then
			local targets = ents.FindInSphere( forcedTargetPos, 3 )
			for k, v in pairs(targets) do
				if (v:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(v)) then
					ent.targetEntity = v
					break;
				end
			end
		end

		if (ent.targetEntity == ent) then ent.targetEntity = nil end
		
		if (IsValid(ent.targetEntity)) then
			if (ent.targetEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(ent.targetEntity)) then
				local heal = math.min(ent.damageDeal, ent.targetEntity:GetVar("maxHP")-ent.targetEntity:GetVar("HP"))
				
				if (heal < ent.HP) then
					local newHealth = ent.targetEntity:GetVar("HP")+heal
					local pos = ent:GetPos()+ent.shotOffset
					local targetPos = ent.targetEntity:GetPos()
					if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
						targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
					end
					//ent:FireBullets(bullet)
					local effectdata = EffectData()
					effectdata:SetOrigin( targetPos + Vector(0,0,10) )
					util.Effect( "inflator_magic", effectdata )
					util.Effect( "inflator_magic", effectdata )
					util.Effect( "inflator_magic", effectdata )
					util.Effect( "inflator_magic", effectdata )
					util.Effect( "inflator_magic", effectdata )
					effectdata:SetOrigin( pos + Vector(0,0,10) )
					util.Effect( "inflator_magic", effectdata )
					sound.Play( ent.shotSound, pos )

					ent.targetEntity:SetVar("HP", newHealth)
					ent.targetEntity:SetNWFloat("health", newHealth)
					ent.fired = true
					if (ent.targetEntity:GetVar("HP") == ent.targetEntity:GetVar("maxHP")) then
						ent.targetEntity = nil
					end
					ent.damage = heal
					ent.nextControlShoot = CurTime()+ent.slowThinkTimer
					return true
				end
			else
				ent.targetentity = nil
			end
		end
	end
	return false
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end