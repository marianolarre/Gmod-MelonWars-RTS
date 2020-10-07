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
        render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
        local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
        local vpos = self:WorldSpaceCenter()+Vector(0,0,16)+angle:Forward()*10-angle:Right()*5/2
        local NST = self:GetNWFloat("nextSlowThink", 0)
        local STT = self:GetNWFloat("slowThinkTimer", 0)
        local OD = self:GetNWFloat("overdrive", 0)*3

        cam.Start3D2D( vpos, angle, 1 )
            if (NST > CurTime()--[[ && self:GetNWBool("spawned", false)]]) then
                surface.SetDrawColor( Color(0,255,255) )
                surface.DrawRect( 0, -15, 5, 35+(math.min(0, CurTime()+OD-NST))*35/STT )
                surface.SetDrawColor( Color(255,240,0) )
                surface.DrawRect( 0, -15, 5, 35+(CurTime()-NST)*35/STT )
                surface.SetDrawColor( Color( 0,0,0, 255 ) )
                surface.DrawOutlinedRect( 0, -15, 5, 35 )
            end
        cam.End3D2D()
end