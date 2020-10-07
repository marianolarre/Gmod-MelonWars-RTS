include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
     self:DrawModel() -- Draws Model Client Side

    local state = self:GetNWInt("state", 0.5)/1000
    local s = 60
    cam.Start3D2D( self:GetPos()+self:GetUp()*63+Vector(0,0,17), self:GetAngles()+Angle(90,0,180), 1 )
        surface.SetDrawColor( Color( 10, 10, 10, 255 ) )
        surface.DrawRect( -s, -s, s*2, s*2 )
        surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
        surface.DrawRect( -10+2, -10+2, 10*2-4, 10*2-4 )
    cam.End3D2D()
end