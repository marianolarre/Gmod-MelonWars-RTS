AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:SetMaterial("models/combine_scanner/scanner_eye")
	self:SetModel("models/props_junk/TrafficCone001a.mdl")
	self:SetColor(Color(255,0,0,255))
	self:SetUseType( SIMPLE_USE )
	self.mw_melonTeam = 0
	self.melonModel = "NO MODEL ASIGNED"
	self.melonParent = nil;
end

function ENT:PostEntityPaste( ply, ent, createdEntities )
	self:SetColor(mw_team_colors[self.mw_melonTeam])
end

function ENT:SetMelonTeam(newteam, model, parent)
	self.mw_melonTeam = newteam
	self.melonModel = model
	self:SetColor(mw_team_colors[self.mw_melonTeam])
end