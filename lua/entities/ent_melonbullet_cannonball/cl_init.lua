include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
end

// New Year
/*function ENT:OnRemove()
	MW_Firework(self, 30, 1)
	MW_Firework(self, 30, 1.5)
end*/