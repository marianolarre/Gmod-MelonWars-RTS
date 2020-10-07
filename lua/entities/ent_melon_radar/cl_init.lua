include('shared.lua')

function ENT:Initialize()
	self.nextBoop = 0
	self.digit = 0
end

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

	local state = self:GetNWFloat("energy", 0)
    local s = 7
    if (self:GetNWBool("working")) then
	    local morze = {1,2,0,2,1,1,1,0,2,2,2,0,1,1,2,0,2,0,0,0}
		local ch = morze[math.floor((CurTime()*2)%(#morze-1))]
		if (CurTime() > self.nextBoop) then
			if (morze[self.digit] == 1) then
				sound.Play( "buttons/blip1.wav", self:GetPos(), 60, 200, 1 )
				self.nextBoop = CurTime()+0.1
			elseif (morze[self.digit] == 2) then
				sound.Play( "buttons/blip1.wav", self:GetPos(), 60, 110, 1 )
				self.nextBoop = CurTime()+0.2
			else
				self.nextBoop = CurTime()+0.75
			end
			self.digit = (self.digit+1)%(#morze)
		end
	end
	cam.Start3D2D( self:GetPos()+Vector(0,0,256), Angle(0,0,0), 1 )
		surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
		surface.DrawRect( -s, -s, s*2, s*2 )
		surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
		surface.DrawRect( -s+2, -s+2, s*2-4, s*2-4 )
	cam.End3D2D()
end