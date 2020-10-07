include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
    local vpos = self:WorldSpaceCenter()+Vector(0,0,50)--+angle:Forward()*10-angle:Right()*10/2

    local timeLeft = self:GetNWFloat("expiration")-CurTime()

	cam.Start3D2D( vpos, angle, 0.5 )
		draw.SimpleText( tostring(math.ceil(timeLeft)), "Trebuchet24", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end