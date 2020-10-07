include('shared.lua')

function ENT:Initialize()
	self.nextParticle = 0
end

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

    if (self:GetNWFloat("countdown", -1) != -1) then
    	local timeLeft = self:GetNWFloat("countdown")-CurTime()
    	local vpos = self:GetPos()+Vector(0,0,30)
		local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local text = "T - "..tostring(math.ceil(timeLeft)).."s"
	    if (timeLeft < 0) then
	    	text = "Ready for Melonium"
	    end
		cam.Start3D2D( vpos, angle, 0.5 )
			draw.SimpleText( text, "Trebuchet24", 1, 1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "Trebuchet24", -1, -1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "Trebuchet24", -1, 1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "Trebuchet24", 1, -1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( text, "Trebuchet24", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end

function ENT:Think()
	if (self:GetNWBool("launching", false)) then
		if (self.nextParticle < CurTime()) then
			MW_SiloSmoke(self, 2)
			self.nextParticle = CurTime()+0.2
		end
	end
end