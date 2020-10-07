include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
     self:DrawModel() -- Draws Model Client Side

    local state = self:GetNWFloat("energy", 0)/self:GetNWFloat("maxenergy", 1)

    render.SetMaterial( Material( "color" ) )
        --render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
    local angle = Angle(-69.5,LocalPlayer():EyeAngles().y,0)
    local vpos = self:WorldSpaceCenter()+Vector(0,0,16)-angle:Forward()*40+angle:Right()*10+angle:Up()*25
    cam.Start3D2D( vpos, angle, 1 )
        --Display de actividad
        if (self:GetNWBool("active", false)) then
            surface.SetDrawColor( Color( 0,255,0, 255 ) )
        else
            surface.SetDrawColor( Color( 255,0,0, 255 ) )
        end
        surface.DrawRect( -10, -15, 50, 10 )
        surface.SetDrawColor( Color( 0,0,0, 255 ) )
        surface.DrawOutlinedRect( -10, -15,50, 10 )
    cam.End3D2D()
end