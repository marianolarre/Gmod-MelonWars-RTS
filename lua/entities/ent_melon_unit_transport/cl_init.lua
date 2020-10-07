include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

    self:TransportDraw(self, 8)
end

function ENT:TransportDraw(self, offset)
	if (cvars.Number("mw_team") == self:GetNWInt("mw_melonTeam", -1)) then
		local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
		local vpos = self:WorldSpaceCenter()+Vector(0,0,16+offset)+angle:Forward()*10-angle:Right()*6
		cam.Start3D2D( vpos, angle, 1 )

			--[[Display de actividad
			if (self:GetNWBool("active", false)) then
				surface.SetDrawColor( Color( 0,255,0, 255 ) )
			else
				surface.SetDrawColor( Color( 255,0,0, 255 ) )
			end
			surface.DrawRect( -10, -15, 10, 10 )
			surface.SetDrawColor( Color( 0,0,0, 255 ) )
			surface.DrawOutlinedRect( -10, -15,10, 10 )]]

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

		local s = 17
		cam.Start3D2D( self:GetPos()+self:GetRight()*33, self:GetAngles()+Angle(0,0,90), 1 )
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )
			surface.DrawRect( -s, -s, s*2, s*2 )
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