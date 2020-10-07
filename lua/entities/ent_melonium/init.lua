AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInitSphere( 10, "metal" )
	self:SetModel("models/maxofs2d/hover_rings.mdl")
	self:GetPhysicsObject():SetDamping(2,2)

	self.lamp = ents.Create( "gmod_light" )
	if ( !IsValid( self.lamp ) ) then return end

	self.lamp:SetParent(self)
	self.lamp:SetLocalPos(Vector(0,0,0))
	self.lamp:SetColor( Color( 50, 255, 0, 255 ) )
	self.lamp:SetBrightness( 100 )
	self.lamp:SetLightSize( 200 )
	self.lamp:SetOn( true )

	self.lamp:Spawn()

	self:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )
	self.lamp:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )

	self:SetNWFloat("death", CurTime()+90)

	sound.Play("items/ammocrate_close.wav", self:GetPos(), 75, 100, 1 )
end

function ENT:Think()
	if (CurTime() > self:GetNWFloat("death", CurTime()+1)) then
		self:Remove()
		sound.Play("weapons/bugbait/bugbait_impact1.wav", self:GetPos(), 75, 100, 1)
	end
end

function ENT:PhysicsCollide( data, phys )
	if (string.StartWith(data.HitEntity:GetClass(), "ent_melon_")) then
		if (data.HitEntity.canMove) then
			if (not data.HitEntity.carryingMelonium) then
				data.HitEntity:SetNWFloat("mw_sick", 30)
				data.HitEntity.carryingMelonium = true
				data.HitEntity.meloniumLamp = self.lamp
				self.lamp:SetParent(data.HitEntity)
				self.lamp:SetLocalPos(Vector(0,0,0))

				sound.Play("items/battery_pickup.wav", self:GetPos(), 75, 100, 1 )

				self:Remove()
			end
		end
	end
end