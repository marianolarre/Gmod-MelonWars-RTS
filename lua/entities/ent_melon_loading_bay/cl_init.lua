include('shared.lua')

local colorMaterial = Material( "trails/electric" )
function ENT:Draw()
	self:DrawModel()
	local found = self:GetNWBool("hasTransport")
	if (found) then
		local target = self:GetNWEntity("transport", nil)
		if (IsValid(target)) then
			local t = (CurTime()*2)%1
			render.SetMaterial( colorMaterial )
			render.DrawBeam( self:GetPos(), target:GetPos(), 5, t, t-1, Color( 255, 255, 255 ) )
		end
	end
end