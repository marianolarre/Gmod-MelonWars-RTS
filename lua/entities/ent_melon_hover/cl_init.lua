include('shared.lua')

function ENT:Initialize()
	self.birth = CurTime()
end

Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
	
	if (self:GetNWBool("done",false) == false) then
		--[[render.SetMaterial( Laser )
		local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
		local vpos = self:WorldSpaceCenter()+Vector(0,0,10)+angle:Forward()*10-angle:Right()*5/2
		cam.Start3D2D( vpos, angle, 1 )
			surface.SetDrawColor( Color(255,240,0) )
			surface.DrawRect( 0, 0, (CurTime()-self.birth)*50/20, 5 )
			surface.SetDrawColor( Color( 0,0,0, 255 ) )
			surface.DrawOutlinedRect( 0, 0, 50, 5 )
		cam.End3D2D()]]
		local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
		local vpos = self:WorldSpaceCenter()+Vector(0,0,20)+angle:Forward()*6+angle:Right()*11
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