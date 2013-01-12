local lumberjack = { pos = {x = 0, y = 0, z = 0}, rot = 1}

-- Getter/setter
function lumberjack:getXPos()
	return self.pos.x
end

function lumberjack:setXPos(pos)
	self.pos.x = pos
end

function lumberjack:getYPos()
	return self.pos.y
end

function lumberjack:setYPos(pos)
	self.pos.y = pos
end

function lumberjack:getZPos()
	return self.pos.z
end

function lumberjack:setZPos(pos)
	self.pos.z = pos
end

function lumberjack:setAtOrigin()
	self:setXPos(0)
	self:setYPos(0)
	self:setZPos(0)
end

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
		self:setYPos( self:getYPos() + 1 )
		
		return true
	end
	
	return false
end

function lumberjack:down()
	if turtle.down() then
		self:setYPos( self:getYPos() - 1 )
	
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
	while self.rot ~= newRot do
		self:turnLeft()
	end
end

function lumberjack:updatePos(distance)
	if self.rot == 1 then
		self:setXPos( self:getXPos() + distance )
	elseif self.rot == 2 then
		self:setZPos( self:getZPos() + distance )
	elseif self.rot == 3 then
		self:setXPos( self:getXPos() - distance )
	elseif self.rot == 4 then
		self:setZPos( self:getZPos() - distance )
	end
	print('X is now ' .. self:getXPos())
	print('Z is now ' .. self:getZPos())
end

function lumberjack:isTreeAhead()
	-- Wood block
	turtle.select(1)
	if turtle.compare() then
		return true
	end
	return false
end

function lumberjack:canDig()
	-- Stone wall block
	turtle.select(3)
	if turtle.compare() then
		return false
	else
		return true
	end
end

function lumberjack:moveAhead()
	local movedAhead = true
	if turtle.detect() then
		if self:isTreeAhead() then
			self:mineTree()
		elseif self:canDig() then
			turtle.dig()
			self:forward()
		else
			movedAhead = false
		end
	else
		self:forward()
	end
	
	return movedAhead
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

function lumberjack:digLine(length, up, down)
	if not up then up = false end
	if not down then down = false end
	
	for block = 1, length, 1 do
		if up then
			turtle.digUp()
			turtle.suckUp()
		end
		if down then
			turtle.digDown()
			turtle.suckDown()
		end
		chopForward(1)
	end
	
	if up then
		turtle.digUp()
		turtle.suckUp()
	end
	if down then
		turtle.digDown()
		turtle.suckDown()
	end
end

-- Based on starting at a corner, facing forwards, with the inside of the ring to the left
function lumberjack:digRing(diameter, up, down)
	for edge = 1, 4, 1 do
		self:digLine(diameter)
		turtle.turnLeft()
	end
end

-- Based on the start at the outmost corner, facing forwards, with the inside of the
-- ring on the left. Spirals inwards, then returns to starting position
function lumberjack:digSpiral(diameter, up, down)
	local currentDiameter = diameter
	while currentDiameter > 0 do
		self:digRing(currentDiameter, up, down)
		
		currentDiameter = currentDiameter - 2
		
		if currentDiameter > 0 then
			-- Move into the next ring
			self:forward()
			self:turnLeft()
			self:forward()
			self:turnRight()
		end
	end
	
	while currentDiameter < diameter do
		self:back()
		self:turnRight()
		self:forward()
		self:turnLeft()
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
		self:chopForward(2)
		self:turnLeft()
		self:chopForward(2)
		self:turnLeft()
		
		
		self:digSpiral(5,false,false)
		
		-- Move back to the middle
		self:turnRight()
		self:back()
		self:back()
		self:turnRight()
		self:back()
		self:back()
		
		-- Move down to the next layers
		if layer < 6 then
			self:down()
		end
	end
	
	turtle.select(2)
	turtle.placeDown()
end

function lumberjack:goTo(x,y,z)
	if self:getZPos() < 0 then
		self:setRot(2)
	else
		self:setRot(4)
	end
	while self:getZPos() ~= z and self:moveAhead() do
	end
	
	if self:getXPos() < 0 then
		self:setRot(1)
	else
		self:setRot(3)
	end
	while self:getXPos() ~= x and self:moveAhead() do
	end
	self:setRot(1)
end

function lumberjack:returnHome()
	print('X from home is ' .. self:getXPos())
	print('Z from home is ' .. self:getZPos())
	print('Y from home is ' .. self:getYPos())

	self:goTo(0,0,0)
end

function lumberjack:hasSpaceFor(slot)
	local hasSpace = false
	for i = 0, 16, 1 do
		if turtle.getItemCount(i) == 0 then
			hasSpace = true
		end
		
		turtle.select(i)
		if turtle.compareTo(slot) then
			if turtle.getItemSpace(i) > 0 then
				hasSpace = true
			end
		end
	end
	return hasSpace
end

function lumberjack:hasSpaceForWood()
	return hasSpaceFor(1)
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
	
	self:dropAllFromTo(4,16)
	
	return true
end

function lumberjack:run()
	repeat
		-- While we have saplings
		while turtle.getItemCount(2) > 1 do
			while self:moveAhead() and self:hasSpaceForWood() do
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