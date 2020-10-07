include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

    --local state = self:GetNWFloat("energy", 0)/self:GetNWFloat("maxenergy", 1)
    --local s = 10
    --cam.Start3D2D( self:GetPos()+Vector(0,0,4), Angle(0,0,0), 1 )
    --    surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
    --    surface.DrawRect( -s, -s, s*2, s*2 )
    --    surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
    --    surface.DrawRect( -s+2, -s+2, s*2-4, s*2-4 )
    --cam.End3D2D()

    render.SetMaterial( Material( "color" ) )
        --render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
    local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
    local vpos = self:WorldSpaceCenter()+Vector(0,0,16)-angle:Forward()*10+angle:Right()*10+angle:Up()*4
    cam.Start3D2D( vpos, angle, 1 )
        --Display de actividad
        if (self:GetNWBool("active", false)) then
            surface.SetDrawColor( Color( 0,255,0, 255 ) )
        else
            surface.SetDrawColor( Color( 255,0,0, 255 ) )
        end
        surface.DrawRect( -10, -15, 10, 10 )
        surface.SetDrawColor( Color( 0,0,0, 255 ) )
        surface.DrawOutlinedRect( -10, -15,10, 10 )
    cam.End3D2D()
end