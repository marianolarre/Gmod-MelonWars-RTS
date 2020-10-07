include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

    local state = self:GetNWInt("state", 0.5)/1000
    local ang = self:GetAngles()
    local w = 100
    local h = 25
    local offset = Vector(-45,0,20)
    offset:Rotate(ang)
    cam.Start3D2D( self:GetPos()+offset, Angle(0,90,100)+ang, 1 )
        surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
        surface.DrawRect( -w, -h, w*2, h*2 )
        surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
        surface.DrawRect( -w+2, -h+2, w*2-4, h*2-4 )
    cam.End3D2D()
    offset = Vector(45,0,20)
    offset:Rotate(ang)
    cam.Start3D2D( self:GetPos()+offset, Angle(0,90,80)+ang, 1 )
        surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
        surface.DrawRect( -w, -h, w*2, h*2 )
        surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
        surface.DrawRect( -w+2, -h+2, w*2-4, h*2-4 )
    cam.End3D2D()
end