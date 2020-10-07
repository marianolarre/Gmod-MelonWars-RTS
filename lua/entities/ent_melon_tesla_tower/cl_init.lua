include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

	local state = self:GetNWInt("state", 0.5)/1000
    local s = 9
	cam.Start3D2D( self:GetPos()+Vector(0,0,40)+self:GetRight()*6+self:GetForward()*1, Angle(0,0,0), 1 )
		surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
		surface.DrawRect( -s, -s, s*2, s*2 )
		surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
		surface.DrawRect( -s+2, -s+2, s*2-4, s*2-4 )
	cam.End3D2D()
end