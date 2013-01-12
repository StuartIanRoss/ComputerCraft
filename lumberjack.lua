local lumberjack = {x = 0, y = 0, z = 0, rot = 1}

-- Wrapper functions around movement to store position
function lumberjack:forward()
	if turtle.forward() then
		self:updatePos(1)
		
		return true
	end
	
	return false
end

function lumberjack:back()
	if turtle.back() then
		self:updatePos(-1)
	
		return true
	end
	
	return false
end

function lumberjack:up()
	if turtle.up() then
		self.y = self.y + 1
		
		return true
	end
	
	return false
end

function lumberjack:down()
	if turtle.down() then
		self.y = self.y - 1
	
		return true
	end
	
	return false
end

function lumberjack:turnLeft()
	turtle.turnLeft()
	
	self.rot = self.rot - 1
	if self.rot < 1 then
		self.rot = 4
	end
end

function lumberjack:turnRight()
	turtle.turnRight()
	
	self.rot = self.rot + 1
	if self.rot > 4 then
		self.rot = 1
	end
end

function lumberjack:setRot(newRot)
	while not self.rot == newRot do
		self:turnLeft()
	end
end

function lumberjack:updatePos(distance)
	if self.rot == 1 then
		self.x = self.x + distance
	elseif self.rot == 2 then
		self.z = self.z + distance
	elseif self.rot == 3 then
		self.x = self.x - distance
	elseif self.rot == 4 then
		self.z = self.z - distance
	end
	print('X is now ' .. x)
	print('Z is now ' .. z)
end

function lumberjack:findTree()
	while true do
		if turtle.detect() then

			-- Wood block
			turtle.select(1)
			if turtle.compare() then
				return true
			end
			
			-- Stone wall block
			turtle.select(3)
			if turtle.compare() then
				return false
			else
				turtle.dig()
			end
		end
		
		self:forward()
	end
end

function lumberjack:chopForward(count)
	if count == nil then
		count = 1
	end
	for i = 1, count, 1 do
		turtle.dig()
		turtle.suck()
		self:forward()
	end
end

function lumberjack:mineTree()
	turtle.select(1)
	if not turtle.compare() then
		return false
	end
	
	-- Move into the trunk column
	turtle.dig()
	self:forward()
	turtle.digDown()
	
	-- Move to the top of the tree
	for i = 1, 5 , 1 do
		turtle.digUp()
		self:up()
	end
	
	-- Mine each layer down
	for layer = 1, 6, 1 do
		-- Move to the outer column of leaves
		chopForward(2)
		
		-- Dig the outer layer
		self:turnLeft()
		chopForward(2)
		for s = 1, 3, 1 do
			self:turnLeft()
			chopForward(4)
		end
		self:turnLeft()
		chopForward(2)
		
		-- Move to the inner layer
		self:turnLeft()
		self:forward()
		self:turnRight()
		
		-- Dig the inner layer
		chopForward()
		for s = 1, 3, 1 do
			self:turnLeft()
			chopForward(2)
		end
		self:turnLeft()
		chopForward()
		
		-- Move back to the middle
		self:turnLeft()
		self:forward()
		self:turnLeft()
		self:turnLeft()
		
		-- Move down to the next layers
		if layer < 6 then
			self:down()
		end
	end
	
	turtle.select(2)
	turtle.placeDown()
end

function lumberjack:returnHome()
	print('X from home is ' .. self.x)
	print('Z from home is ' .. self.z)
	print('Y from home is ' .. self.y)

	if self.z < 0 then
		self:setRot(2)
	else
		self:setRot(4)
	end
	while self.z ~= 0) do
		self:forward()
	end
	
	if self.x < 0 then
		self:setRot(1)
	else
		self:setRot(3)
	end
	while self.x ~= 0 do
		self:forward()
	end
	self:setRot(1)
end

function lumberjack:dropAllLike(sourceSlot, startSlot)
	for i = startSlot , 16, 1 do
		turtle.select(i)
		if turtle.compareTo(sourceSlot) then
			if not turtle.dropDown() then
				return false
			end
		end
	end
	
	return true
end

function lumberjack:dropAllFromTo(startSlot,endSlot)
	for i =startSlot, endSlot, 1 do
		turtle.select(i)
		turtle.dropDown()
	end
end

function lumberjack:emptyToChest()
	local slotCount = turtle.getItemCount(1)
	
	turtle.select(1)
	if not turtle.dropDown(slotCount - 1) then
		return false
	end
	
	-- Drop remaining wood blocks
	--if not dropAllLike(1,4) then
	--	return false
	--end
	
	--slotCount = turtle.getItemCount(2)
	--turtle.select(2)
	--if not turtle.dropDown(slotCount - 1) then
	--	return false
	--end
	
	-- Drop saplings not in main slot
	--if not dropAllLike(2,4) then
	--	return false
	--end
	
	self:dropAllFromTo(4,16)
	
	return true
end

function lumberjack:run()
	repeat
		-- While we have saplings
		while turtle.getItemCount(2) > 1 do
			if self:findTree() then
				self:mineTree()
			end

			self:returnHome()
			while not self:emptyToChest() do
				print('Chest is full')
			end
		end
		print('No saplings in slot 2')
	until true -- Should be false to run infinitely
end

lumberjack:run()