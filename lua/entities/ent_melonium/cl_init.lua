include('shared.lua')

function ENT:Initialize()
	self.nextParticle = 0
end

function ENT:Draw()
    self:DrawModel() -- Draws Model Client Side

    if (self:GetNWFloat("death", -1) != -1) then
    	local timeLeft = self:GetNWFloat("death")-CurTime()
    	local vpos = self:GetPos()+Vector(0,0,15)
		local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local text = tostring(math.ceil(timeLeft))
	    if (timeLeft < 0) then
	    	text = "0"
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
	if (self.nextParticle < CurTime()) then
		MW_SickEffect(self, 1)
		self.nextParticle = CurTime()+0.2
	end
end

function ENT:OnRemove()
	MW_SickEffect(self, 50)
end