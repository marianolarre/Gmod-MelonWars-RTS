include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
    if (cvars.Number("mw_team") == self:GetNWInt("capTeam", -1)) then
		local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
		local vpos = self:WorldSpaceCenter()+Vector(0,0,40)+angle:Forward()*7+angle:Right()*7
		cam.Start3D2D( vpos, angle, 1 )

			--Display de actividad
			surface.SetDrawColor( Color( 0,100,50, 255 ) )
			surface.DrawRect( -10, -15, 10, 10 )
			surface.SetDrawColor( Color( 0,255,0, 255 ) )
			surface.DrawOutlinedRect( -10, -15,10, 10 )
			surface.SetDrawColor( Color( 255,255,255, 255 ) )
			surface.DrawRect( -8, -12, 6, 1 )
			surface.DrawRect( -8, -12, 1, 4 )
			surface.DrawRect( -5, -12, 1, 4 )
			surface.DrawRect( -3, -12, 1, 4 )
		cam.End3D2D()
	end
end