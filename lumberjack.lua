function findTree(vecFromHome)
	while true do
		if turtle.detect()  then
			-- Wood block
			turtle.select(1)
			if turtle.compare() then
				return true
			end
			
			-- Leaf block
			turtle.select(3)
			if turtle.compare then
				turtle.dig()
			else
				return false
			end
		end
		
		turtle.forward()
		vecFromHome.x = vecFromHome.x + 1
	end
end

function chopForward(count)
	if count == nil then
		count = 1
	end
	for i = 1, count, 1 do
		turtle.dig()
		turtle.suck()
		turtle.forward()
	end
end

function mineTree(vecFromHome)
	turtle.select(1)
	if not turtle.compare() then
		return false
	end
	
	-- Move into the trunk column
	turtle.dig()
	turtle.forward()
	vecFromHome.x = vecFromHome.x + 1
	turtle.digDown()
	
	-- Move to the top of the tree
	for i = 1, 5 , 1 do
		turtle.digUp()
		turtle.up()
	end
	
	-- Mine each layer down
	for layer = 1, 5, 1 do
		-- Move to the outer column of leaves
		chopForward(2)
		
		-- Dig the outer layer
		turtle.turnLeft()
		chopForward(2)
		for s = 1, 3, 1 do
			turtle.turnLeft()
			chopForward(4)
		end
		turtle.turnLeft()
		chopForward(2)
		
		-- Move to the inner layer
		turtle.turnLeft()
		turtle.forward()
		turtle.turnRight()
		
		-- Dig the inner layer
		chopForward()
		for s = 1, 3, 1 do
			turtle.turnLeft()
			chopForward(2)
		end
		turtle.turnLeft()
		chopForward()
		
		-- Move back to the middle
		turtle.turnLeft()
		turtle.forward()
		turtle.turnLeft()
		turtle.turnLeft()
		
		-- Move down to the next layers
		turtle.down()
	end
	
	turtle.select(2)
	turtle.placeDown()
end

function returnHome(vecFromHome)
	print('X from home is ' .. vecFromHome.x)
	print('Z from home is ' .. vecFromHome.z)
	print('Y from home is ' .. vecFromHome.y)
	
	if(vecFromHome.z < 0) then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	while(vecFromHome.z > 0) do
		turtle.forward()
		vecFromHome.z = vecFromHome.z - 1
	end
	
	if(vecFromHome.x < 0) then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	while(vecFromHome.x > 0) do
		turtle.forward()
		vecFromHome.x = vecFromHome.x - 1
	end
	turtle.turnLeft()
	turtle.turnLeft()
end

function dropAllLike(sourceSlot, startSlot)
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

function emptyToChest()
	local slotCount = turtle.getItemCount(1)
	
	turtle.select(1)
	if not turtle.dropDown(slotCount - 1) then
		return false
	end
	
	-- Drop remaining wood blocks
	if not dropAllLike(1,4) then
		return false
	end
	
	--slotCount = turtle.getItemCount(2)
	--turtle.select(2)
	--if not turtle.dropDown(slotCount - 1) then
	--	return false
	--end
	
	-- Drop saplings not in main slot
	if not dropAllLike(2,4) then
		return false
	end
	
	return true
end

vecFromHome = { x = 0, y = 0, z = 0 }

repeat

	-- While we have saplings
	while turtle.getItemCount(2) > 1 do
		if( findTree(vecFromHome) ) then
			mineTree(vecFromHome)
		end

		returnHome(vecFromHome)
		while not emptyToChest() do
			print('Chest is full')
		end
	end
	print('No saplings in slot 2')
until true