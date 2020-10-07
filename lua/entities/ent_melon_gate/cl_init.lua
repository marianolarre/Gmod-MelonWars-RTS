include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

	render.SetMaterial( Material( "color" ) )

    render.DrawBeam( self:GetPos(), self:GetPos()+Vector(0,0,-110), 2, 1, 1, Color( 50, 50, 50, 255 ) )

    local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
    local vpos = self:WorldSpaceCenter()+Vector(0,0,16)-angle:Forward()*10+angle:Right()*10+angle:Up()*4
    cam.Start3D2D( vpos, angle, 1 )
        --Display de actividad
        if (self:GetNWBool("open", false)) then
            surface.SetDrawColor( Color( 0,255,0, 255 ) )
        else
            surface.SetDrawColor( Color( 255,0,0, 255 ) )
        end
        surface.DrawRect( -10, -15, 10, 10 )
        surface.SetDrawColor( Color( 0,0,0, 255 ) )
        surface.DrawOutlinedRect( -10, -15,10, 10 )
    cam.End3D2D()
end