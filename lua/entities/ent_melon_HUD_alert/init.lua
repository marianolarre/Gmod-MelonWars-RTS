AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self:DrawShadow( false )
	timer.Simple(5,function ()
		if (IsValid(self)) then
			self:Remove()
		end
	end)
end