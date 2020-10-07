include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
     self:DrawModel() -- Draws Model Client Side

    local state = self:GetNWFloat("energy", 0)/self:GetNWFloat("maxenergy", 1)

    render.SetMaterial( Material( "color" ) )
        --render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
    local angle = self:GetAngles()
    local vpos = self:WorldSpaceCenter()+Vector(0,0,-52)
    cam.Start3D2D( vpos, angle, 1 )
        --Display de actividad
        if (self:GetNWBool("active", false)) then
            surface.SetDrawColor( Color( 0,255,0, 255 ) )
        else
            surface.SetDrawColor( Color( 255,0,0, 255 ) )
        end
        surface.DrawRect( -60, -30, 30, 60 )
        surface.SetDrawColor( Color( 0,0,0, 255 ) )
        surface.DrawOutlinedRect( -60, -30,30, 60 )
    cam.End3D2D()
end