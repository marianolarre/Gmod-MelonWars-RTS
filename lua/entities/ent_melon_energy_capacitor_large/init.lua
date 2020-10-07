AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	MW_Energy_Defaults ( self )

	self.modelString = "models/props_combine/combine_train02a.mdl"
	self.maxHP = 500
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,100))
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.moveType = MOVETYPE_NONE
	self.connections = {}

	self.canMove = false
	self.careForFriendlyFire = false
	self.population = 0

	self.capacity = 15000
	self:SetNWVector("energyPos", Vector(0,0,30))

	MW_Energy_Setup ( self )
end

function ENT:Think(ent)
	self:Energy_Set_State()
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
			util.BlastDamage( ent, ent, ent:GetPos(), 500, 300 + self:GetNWInt("energy", 0)/self:GetNWInt("maxenergy", 1)*1000 )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "Explosion", effectdata )

			local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,150))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,-150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(110,110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-110,110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(110,-110,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-110,-110,0))
				util.Effect( "Explosion", effectdata )
			
			local pos1 = ent:GetPos()// Set worldpos 1. Add to the hitpos the world normal.
			local pos2 = ent:GetPos()+Vector(0,0,-20) // Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()
			
			util.Decal("Scorch",pos1,pos2)
		end
	end)
end