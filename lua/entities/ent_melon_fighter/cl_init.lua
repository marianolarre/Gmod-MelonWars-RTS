include('shared.lua')

function ENT:Draw()
    self:DrawModel() -- Draws Model Client Side
    local percent = self:GetNWInt("fuel", 100)/300
	if (percent < 1) then
	    local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local vpos = self:WorldSpaceCenter()+Vector(0,0,10)--+angle:Forward()*10-angle:Right()*10/2
		cam.Start3D2D( vpos, angle, 1 )
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect( -21, -1, 42, 7 )
			surface.SetDrawColor(255, 255, 0)
			surface.DrawRect( -20, 0, 40*percent, 5 )
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self.circleSize = 0
	self.clientvel = Angle(0,0,0)
end

function ENT:Think()
	local vel = self:GetVelocity()
	vel.z = 0
	if (vel:LengthSqr() > 50) then
		self.clientvel = vel:Angle()+Angle(0,45,0)
	end
	self:SetAngles(self.clientvel)

	local pos = self:GetPos()
	local tr = util.TraceLine( {
	start = pos+Vector(0,0,20),
	endpos = pos+Vector(0,0,-350),
	filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end,
	mask = bit.bor(MASK_SOLID,MASK_WATER)
	} )
	self.floorTrace = tr

	if (self.circleSize == 0) then
		local baseSize = self:GetNWFloat("baseSize", -1)
		if (baseSize > -1) then
			self.circleSize = baseSize
		end
	end

	self:ClientThink()
end