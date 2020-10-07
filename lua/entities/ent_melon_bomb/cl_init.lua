include('shared.lua')

function ENT:ClientThink()
	if (self.t == nil or self.t == -1) then
		self.t = self:GetNWInt("mw_melonTeam", -1)
	end
	if (self.m == nil) then
		if (self:GetMoveType() != nil) then
			self.m = self:GetMoveType()
		end
	end
end

// New Year
/*function ENT:OnRemove()
	MW_Firework(self, 50, 1.5)
	MW_Firework(self, 50, 2)
end*/