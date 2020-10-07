AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local Network = {}
Network.active = true
Network.name = "Nameless network"
Network.energy = 0
Network.capacity = 0
Network.elements = {}

function MW_Network()
	local newNetwork = table.Copy( Network )
	return newNetwork
end

mw_electric_network = {}

function MW_CalculateConnections(ent, all)
	timer.Simple(0.05, function ()
		constraint.RemoveConstraints( ent, "Rope" )
		local foundEntities = table.Add(foundConnections, ents.FindInSphere(ent:GetPos(), ent.connectionRange))
		local count = 0
		local hasConnection = false
			--find every energy entity
		local pos = ent:OBBCenter()
		table.sort( foundEntities, function( a, b ) return ((a:GetPos()-pos):LengthSqr() < (b:GetPos()-pos):LengthSqr()) end )
		for k, v in pairs(foundEntities) do
			if (count >= 3) then break end
			if (v != ent) then
				if ((all == true and v.Base == "ent_melon_energy_base") or (all == false and v.connectToMachines) or (ent.connectToRelaysOnly == true and string.StartWith(v:GetClass(), "ent_melon_energy_relay"))) then
					if (v.allowConnections == true) then
						if (ent:SameTeam(v)) then
							table.insert(ent.connections, v)
							table.insert(v.connections, ent)
							if (!all or string.StartWith(v:GetClass(), "ent_melon_energy_relay")) then
								count = count + 1
							end
							hasConnection = true
						end
					end
				end
			end
		end
		--wires!
		for k, v in pairs(ent.connections) do
			constraint.Rope( ent, v, 0, 0, ent:GetNWVector("energyPos",Vector(0,0,0)), v:GetNWVector("energyPos",Vector(0,0,0)), ent:LocalToWorld( ent:GetNWVector("energyPos",Vector(0,0,0)) ):Distance(v:LocalToWorld( v:GetNWVector("energyPos",Vector(0,0,0)) )), 100, 1, 3, "cable/cable2", false )
		end
		--include self in network system
		if (hasConnection == false) then
			--no connections make new network
			MW_Energy_Network_New(ent)
		else
			local nw = -1
			for k, v in pairs(ent.connections) do
				local othernw = v.network
				if (nw == -1) then
					nw = othernw
					MW_Energy_Network_Insert_Element(ent, nw)
				else
					if (nw != othernw) then
						MW_Energy_Network_Merge(ent, nw, othernw)
					end
				end
				MW_CleanUp_Network(othernw)
			end
			MW_CleanUp_Network(nw)
		end
	end)
end

function MW_CleanUp_Network(network)
	local deleted = 0
	for k, v in pairs(mw_electric_network[network].elements) do
		if (!IsValid(mw_electric_network[network].elements[k-deleted])) then
			table.remove( mw_electric_network[network].elements, k-deleted )
			deleted = deleted+1
		end
	end
	if (table.Count(mw_electric_network[network].elements) == 0) then
		MW_Energy_Deactivate_Network(mw_electric_network[network])
	end
end

function MW_Energy_Network_New(ent)
	local newNetwork = nil
	local recycled = false
	local index = 0
	for k, v in pairs(mw_electric_network) do
		if (recycled == false) then
			if (v.active == false) then
				v.active = true
				index = k
				newNetwork = v
				recycled = true
				break
			end
		end
	end
	if (recycled == false) then
		newNetwork = MW_Network()
		index = table.insert(mw_electric_network, newNetwork)
	end

	newNetwork.name = "Network "..index
	ent:SetNetwork(index)
end

function MW_Energy_Network_Merge(ent, networkA, networkB)
	--MW_Energy_Network_Insert_Element(ent, networkA)
	local nwa = mw_electric_network[networkA]
	local nwb = mw_electric_network[networkB]
	--nwa.capacity = nwa.capacity + nwb.capacity
	nwa.energy = nwa.energy + nwb.energy
	local count = table.Count(nwb.elements)
	local safety = 0
	for i=1, count do
		nwb.elements[1]:SetNetwork(networkA)
		if (safety >= 10000) then break end
	end
	if (safety >= 10000) then error("SAFETY MERGE STOP") end
	MW_Energy_Deactivate_Network(nwb)
end

function MW_Energy_Network_Insert_Element(ent, network)
	MW_CleanUp_Network(network)
	local nw = mw_electric_network[network]
	nw.active = true
	nw.capacity = nw.capacity + ent.capacity
	table.insert(nw.elements, ent)
	ent.network = network
	ent:SetNWInt("network", network)
end

function MW_Energy_Network_Remove_Element(ent)
	local network = ent.network
	local nw = mw_electric_network[network]
	if (nw != nil) then
		nw.energy = nw.energy-ent:GetEnergy()
		nw.capacity = nw.capacity - ent.capacity
		table.RemoveByValue( nw.elements, ent )
		local touched = {}
		local ambassador = nil
		local totalSeparatedEnergy = 0
		for k, v in pairs(ent.connections) do
			if (k == 1) then
				ambassador = v
				v.alreadySet = true
				table.insert(touched, v)
			else
				local searched, found = MW_Energy_Network_Search(v, ambassador)
				if (istable(searched)) then
					if (found == false) then
						if (v.alreadySet == false) then
							local separatedEnergy = 0
							local newNetwork = 0
							for j, i in pairs(searched) do
								separatedEnergy = separatedEnergy + i:GetEnergy(i.network)
								if (j == 1)  then
									MW_Energy_Network_New(i)
									newNetwork = i.network
								else
									i:SetNetwork(newNetwork)
								end
								i.alreadySet = true
								table.insert(touched, i)
							end
							mw_electric_network[newNetwork].energy = separatedEnergy
							totalSeparatedEnergy = totalSeparatedEnergy + separatedEnergy
						end
						for j, i in pairs(searched) do
							table.insert(touched, i)
						end
					end
				end
			end
		end
	end
	if (istable(touched)) then
		for k, v in pairs(touched) do
			v.alreadySet = false
			v.alreadySearched = false
		end
		table.Empty(touched)
	end
	MW_CleanUp_Network(network)
end

function MW_Energy_Network_Search(ent, targetEnt)
	local openList = {}
	local closedList = {}
	local foundEnt = nil
	local safety = 0
	table.insert(openList, ent)
	while(table.Count(openList) > 0 and foundEnt == nil and safety < 10000) do
		local current = openList[1]
		
		current.alreadySearched = true
		table.insert(closedList, current)
		table.RemoveByValue(openList, current)
		for k, v in pairs(current.connections) do
			if (v == ent) then continue end
			if (v.alreadySearched == false) then
				if (v == targetEnt) then
					foundEnt = v
					current.alreadySet = true
				end
				table.insert(openList, v)
				v.alreadySearched = true
			end
		end
		safety = safety + 1
	end
	if (safety == 10000) then
		error("SAFETY SEARCH STOP")
	end
	local found = (foundEnt != nil)
	table.Add(closedList, openList)
	for k, v in pairs(closedList) do
		v.alreadySearched = false
	end
	return closedList, found
end

function MW_Energy_Deactivate_Network(nw)
	nw.active = false
	nw.capacity = 0
	table.Empty(nw.elements)
	nw.energy = 0
	nw.name = "Network"
end

function MW_Energy_Defaults( ent )
	MW_Defaults(ent)

	ent.moveType = MOVETYPE_NONE
	ent.connections = {}
	ent.capacity = 0
	ent.canMove = false
	ent.slowThinkTimer = 10
	ent.connectToMachines = false
	ent.connectToRelaysOnly = false
	ent.allowConnections = true
	ent.alreadySearched = false
	ent.alreadySet = false
	ent.connectionRange = 200

	ent.network = 0

	ent:SetNWFloat("percentage", 0)
end

function MW_Energy_Setup( ent )
	MW_Setup(ent)
	MW_CalculateConnections(ent, ent.connectToMachines)
end

function ENT:Energy_Set_State()
	local energy = mw_electric_network[self.network].energy
	if (tostring(energy) == "nan") then
		mw_electric_network[self.network].energy = 0
		energy = 0
	end
	local max = mw_electric_network[self.network].capacity
	local message = "Energy: "..energy.." / "..max
	local state = math.Round(energy/max*1000)
	if (max == 0) then
		message = "No energy capacity.\nConnect batteries!"
		state = 0
	end
	self:SetNWString("message", message)
	self:SetNWInt("state", state)
end

function ENT:Energy_Add_State()
	local energy = mw_electric_network[self.network].energy
	if (tostring(energy) == "nan") then
		mw_electric_network[self.network].energy = 0
		energy = 0
	end
	local max = mw_electric_network[self.network].capacity
	local message = "Energy: "..energy.." / "..max
	local state = math.Round(energy/max*1000)
	if (max == 0) then
		message = "No energy capacity.\nConnect batteries!"
		state = 0
	end
	self:SetNWString("message", self:GetNWString("message","").."\n"..message)
	self:SetNWInt("state", state)
end

function ENT:OnRemove()
	if (istable(self.connections)) then
		for k, v in pairs(self.connections) do
			table.RemoveByValue(v.connections, self)
		end
	end
	MW_Energy_Network_Remove_Element(self)
	self:DefaultOnRemove()
end

function ENT:SetNetwork(network)
	local previousNetwork = self.network

	if (previousNetwork > 0) then
		if (previousNetwork != nil) then
			local prevnw = mw_electric_network[previousNetwork]
			prevnw.energy = prevnw.energy-self:GetEnergy()
			prevnw.capacity = prevnw.capacity - self.capacity
			table.RemoveByValue( prevnw.elements, self )
			if (table.Count( prevnw.elements ) == 0) then
				MW_Energy_Deactivate_Network(prevnw)
			end
		end
	end

	MW_Energy_Network_Insert_Element(self, network, self:GetEnergy(previousNetwork))
end

function ENT:GetEnergy(network)
	if (network == nil) then
		network = self.network
	end
	if(self.network > 0) then
		return math.floor(mw_electric_network[self.network].energy*(self.capacity/mw_electric_network[self.network].capacity))
	else
		return 0 
	end
end

function ENT:DrainPower(power)
	local enough = false
	if (mw_electric_network[self.network].energy >= power) then
		enough = true
		mw_electric_network[self.network].energy = mw_electric_network[self.network].energy - power
	end
	return enough
end

function ENT:GivePower(power)
	local can = true
	if (self.network > 0) then
		local nw = mw_electric_network[self.network]
		if (nw.energy+power > nw.capacity) then
			can = false
		else
			nw.energy = nw.energy + power
		end
	end
	return can
end