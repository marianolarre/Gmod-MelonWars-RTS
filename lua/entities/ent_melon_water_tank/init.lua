AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(255,50,255,255),Color(100,255,255,255),Color(255,120,0,255),Color(10,30,70,255)}

function ENT:Initialize()
	
	self.slowThinkTimer = 2

	self.mw_melonTeam = 0
	
	self.nextSlowThink = 0
	
	self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	
	--self:SetAngles(Angle(90,0,0))
	//self:SetPos(self:GetPos()+Vector(0,0,25))
	
	self:SetMaterial("models/shiny")
	
	self.captured = {0,0,0,0,0,0,0,0}
	for i=1, 8 do
		self:SetNWInt("captured"..tostring(i), 0)
	end
	self.capTeam = 0
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)
	--local weld = constraint.Weld( self, game.GetWorld(), 0, 0, 0, true , false )
end

function ENT:OnDuplicated( entTable )
	//self:SetPos(self:GetPos()-Vector(0,0,25))
end

function ENT:Think()
	if (cvars.Bool("mw_admin_cutscene")) then return end
	if (cvars.Bool("mw_admin_playing") ) then 
		if (CurTime() > self.nextSlowThink) then
			self.nextSlowThink = CurTime()+self.slowThinkTimer
			self:SlowThink( self )
		end
	end
end

function ENT:SlowThink()

	--[[
	if (SERVER) then
		if (self.capTeam ~= 0) then
			mw_teamCredits[self.capTeam] = mw_teamCredits[self.capTeam]+5
			for k, v in pairs( player.GetAll() ) do
				if (v:GetInfo("mw_team") == tostring(self.capTeam)) then
					net.Start("MW_TeamCredits")
						net.WriteInt(mw_teamCredits[self.capTeam] ,32)
					net.Send(v)
				end
			end
		end
	end
	]]

	local capturing = {0,0,0,0,0,0,0,0}

	local foundEnts = ents.FindInSphere(self:GetPos(), 200 )
	for k, v in RandomPairs( foundEnts ) do
		if (v.Base == "ent_melon_base") then
			if (v:GetNWInt("mw_melonTeam", 0) >= 1) then
				capturing[v:GetNWInt("mw_melonTeam", 0)] = capturing[v:GetNWInt("mw_melonTeam", 0)]+v.captureSpeed
				
				local effectdata = EffectData()
				effectdata:SetScale(0)
				effectdata:SetStart(v:GetPos()+Vector(0,0,20))
				effectdata:SetOrigin(v:GetPos()+Vector(0,0,20))
				util.Effect( "MuzzleEffect", effectdata )
			end
		end
	end

	for i=1,8 do 
		local capture = math.Round(math.sqrt(capturing[i]))*4
		--Si hay gente capturando
		if (capturing[i] > 0) then
			local othersHaveCapture = false
			for ii=1,8 do 
				if (ii ~= i) then
					--Si alguien más estaba capturando
					if (self.captured[ii] > 0) then
						--Bajar su captura
						self.captured[ii] = self.captured[ii]-capture
						othersHaveCapture = true
					end
				end
			end
			--Si nadie estaba capturando, capturar
			if (!othersHaveCapture) then
				self.captured[i] = math.min(100, self.captured[i]+capture)
			end
		else 
		--Si no, bajarle
			self.captured[i] = math.max(0, self.captured[i]-20)
		end
	end 

	local totalCapture = 0

	for i=1,8 do 
		totalCapture = totalCapture + self.captured[i]
	end
	
	if (totalCapture == 100) then
		for i=1,8 do 
			if (self.captured[i] == totalCapture) then
				self:GetCaptured(i, self)
			end
		end
	end
	
	if (totalCapture == 0) then
		self:GetCaptured(0, self)
	end
	
	if (self.captured[self.capTeam] == 0) then
		self:GetCaptured(0, self)
	end
	
	for i=1, 8 do
		self:SetNWInt("captured"..tostring(i), self.captured[i])
	end
end

function ENT:GetCaptured(capturingTeam, ent)
	local newColor = Color(255,255,255,255)
	if (capturingTeam > 0) then newColor = mw_team_colors[capturingTeam] end
	--[[if (capturingTeam == 1) then
		newColor = Color(255,50,50,255)
	end
	if (capturingTeam == 2) then
		newColor = Color(50,50,255,255)
	end
	if (capturingTeam == 3) then
		newColor = Color(255,255,50,255)
	end
	if (capturingTeam == 4) then
		newColor = Color(30,200,30,255)
	end
	if (capturingTeam == 5) then
		newColor = Color(255,50,255,255)
	end
	if (capturingTeam == 6) then
		newColor = Color(50,255,255,255)
	end
	if (capturingTeam == 7) then
		newColor = Color(255,120,0,255)
	end
	if (capturingTeam == 8) then
		newColor = Color(10,30,70,255)
	end]]
	
	ent.capTeam = capturingTeam
	ent:SetNWInt("capTeam", capturingTeam)
	
	ent:SetColor(newColor)
end