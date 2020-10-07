include('shared.lua')

function ENT:Initialize()
	self.nextParticle = 0
end

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
end

function ENT:Think()
	if (self.nextParticle < CurTime()) then
		MW_SickEffect(self, 3)
		self.nextParticle = CurTime()+0.02
	end
end

function ENT:OnRemove()
	MW_SickExplosion(self, 300)
end