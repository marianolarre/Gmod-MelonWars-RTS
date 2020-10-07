include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
    local time = self:GetNWFloat("spawnTime",0)
    if (CurTime() < time) then
	    local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local vpos = self:WorldSpaceCenter()--+angle:Forward()*10-angle:Right()*10/2
		cam.Start3D2D( vpos, angle, 0.5 )
			draw.SimpleText( tostring(math.ceil(time-CurTime())), "Trebuchet24", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end

	self:DrawExpirationDate()

	/* Selection bug debuging */
	if (self:GetNWBool("spawned", false)) then
		local mteam = self:GetNWInt("mw_melonTeam", -5)
		if (mteam == -5) then
			local vpos = self:GetPos()+Vector(0,0,30)
			local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
		    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
			cam.Start3D2D( vpos, angle, 0.5 )
				draw.SimpleText( "Dammit i forgot what team im in", "Trebuchet18", 0, 0, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end
	end
end

function ENT:Initialize()
	self.circleSize = 0
	self.nextParticle = 0
end

function ENT:Think()
	local pos = self:GetPos()
	local tr = util.TraceLine( {
	start = pos+Vector(0,0,20),
	endpos = pos+Vector(0,0,-280),
	filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end,
	mask = bit.bor(MASK_SOLID,MASK_WATER)
	} )
	self.floorTrace = tr

	if (self.circleSize == 0) then
		local baseSize = self:GetNWFloat("baseSize", -1)
		if (baseSize > -1) then
			self.circleSize = baseSize
		end
	end

	if (self.nextParticle ~= nil) then
		if (self.nextParticle < CurTime()) then
			local sick = self:GetNWFloat("mw_sick", 0)
			if (sick > 0) then
				MW_SickEffect(self, 1)
				self.nextParticle = CurTime()+math.min(1/sick, 1)
			end
		end
	end

	self:ClientThink()
end

function ENT:DrawExpirationDate()
	if (self:GetNWFloat("expiration", -1) != -1) then
		local vpos = self:GetPos()+Vector(0,0,30)
		local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
		local timeLeft = self:GetNWFloat("expiration")-CurTime()
		cam.Start3D2D( vpos, angle, 0.5 )
			draw.SimpleText( tostring(math.ceil(timeLeft)), "Trebuchet18", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end

function ENT:ClientThink()
end

function BarrackDraw(self, offset)
	if (cvars.Number("mw_team") == self:GetNWInt("mw_melonTeam", -1)) then
		render.SetMaterial( Material( "color" ) )
        --render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
        local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
        local vpos = self:WorldSpaceCenter()+Vector(0,0,16)+Vector(0,0,offset)+angle:Forward()*10-angle:Right()*5/2
        local NST = self:GetNWFloat("nextSlowThink", 0)
        local STT = self:GetNWFloat("slowThinkTimer", 0)
        local OD = self:GetNWFloat("overdrive", 0)
        cam.Start3D2D( vpos, angle, 1 )
        	if (!self:GetNWBool("spawned", false)) then
	            if (NST > CurTime()) then
	                surface.SetDrawColor( Color(0,255,255) )
	                surface.DrawRect( 0, -15, 5, math.min(35, 35+(CurTime()+OD-NST)*35/STT) )
	                surface.SetDrawColor( Color(255,240,0) )
	                surface.DrawRect( 0, -15, 5, 35+(CurTime()-NST)*35/STT )
	                surface.SetDrawColor( Color( 0,0,0, 255 ) )
	                surface.DrawOutlinedRect( 0, -15, 5, 35 )
	            end
	        end
			--Display de actividad
			if (self:GetNWBool("active", false)) then
				surface.SetDrawColor( Color( 0,255,0, 255 ) )
			else
				surface.SetDrawColor( Color( 255,0,0, 255 ) )
			end
			surface.DrawRect( -10, -15, 10, 10 )
			surface.SetDrawColor( Color( 0,0,0, 255 ) )
			surface.DrawOutlinedRect( -10, -15,10, 10 )

			--Display de unidades
			surface.SetDrawColor( Color( 50,50,50, 255 ) )
			local m = self:GetNWInt("maxunits", 0)
			for i=1, 5 do
				if (i <= m) then
					surface.DrawRect( -5, -10+i*5,5, 5 )
				end
			end
			for i=6, 10 do
				if (i <= m) then
					surface.DrawRect( -10, -10+(i-5)*5,5, 5 )
				end
			end
			surface.SetDrawColor( Color( 255,255,255, 255 ) )
			local c = self:GetNWInt("count", 0)
			surface.DrawRect( -5, -5,5, math.min(c,5)*5 )
			if (c > 5) then
				surface.DrawRect( -10, -5,5, (c-5)*5 )
			end

			surface.SetDrawColor( Color( 0,0,0, 255 ) )
			for i=1, 5 do
				if (i <= m) then
					surface.DrawOutlinedRect( -5, -10+i*5,5, 5 )
				end
			end
			for i=6, 10 do
				if (i <= m) then
					surface.DrawOutlinedRect( -10, -10+(i-5)*5,5, 5 )
				end
			end
		cam.End3D2D()
	end

	local time = self:GetNWFloat("spawnTime",0)
    if (CurTime() < time) then
	    local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local vpos = self:WorldSpaceCenter()--+angle:Forward()*10-angle:Right()*10/2
		cam.Start3D2D( vpos, angle, 0.5 )
			draw.SimpleText( tostring(math.ceil(time-CurTime())).."s", "Trebuchet24", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end

function ENT:OnRemove()
	for k, v in pairs(self:GetChildren()) do
		v:Remove()
	end
end

// New Year
/*function ENT:OnRemove()
	MW_Firework(self, 50, 1)
end*/