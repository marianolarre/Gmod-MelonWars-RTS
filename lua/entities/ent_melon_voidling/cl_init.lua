include('shared.lua')

--function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
--    self:DrawModel() -- Draws Model Client Side
--end

function ENT:OnRemove()
	MW_VoidExplosion(self, 50, 1)
end