include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

    local open = self:GetNWBool("open")
	local state = 0
	if (open) then
		state = 1
	end
    local s = 11
	cam.Start3D2D( self:GetPos()+Vector(0,0,20), Angle(0,0,0), 1 )
		surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
		surface.DrawRect( -s, -s, s*2, s*2 )
		surface.SetDrawColor( Color( (1-state)*255, state*255, 0, 255 ) )
		surface.DrawRect( -s+2, -s+2, s*2-4, s*2-4 )

		--debug--
		--[[
		surface.SetFont( "DermaLarge" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 10, -10 )
		surface.DrawText( self:GetNWInt("network", "-") )
		]]
		---------
	cam.End3D2D()
end