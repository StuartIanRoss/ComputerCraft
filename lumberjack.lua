function findTree(vecFromHome)
	while true do
		if( turtle.detect() ) then
			turtle.select(1)
			if (turtle.compare()) then
				return true
			else
				return false
			end
		else
			turtle.forward()
			vecFromHome.x = vecFromHome.x + 1
		end
	end
end

function mineTree()
	turtle.select(1)
	if(not turtle.compare()) then
		return false
	end
	
	-- Move into the trunk column
	turtle.dig()
	turtle.forward()
	turtle.digDown()
	
	-- Move to the top of the tree
	for i = 0, 7 , 1 do
		turtle.digUp()
		turtle.up()
	end
	
	-- Mine each layer down
	for layer = 0, 7, 1 do
		-- Move to the outer column of leaves
		if turtle.detect() then turtle.dig() end
		turtle.forward()
		if turtle.detect() then turtle.dig() end
		turtle.forward()
		
		-- Dig the outer layer
		turtle.turnLeft()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		for s = 0, 3, 1 do
			turtle.turnLeft()
			for col = 0, 3, 1 do
				turtle.dig()
				turtle.suck()
				turtle.forward()
			end
		end
		turtle.turnLeft()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		
		-- Dig the inner layer
		turtle.turnLeft()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		for s = 0, 3, 1 do
			turtle.turnLeft()
			for col = 0, 3, 1 do
				turtle.dig()
				turtle.suck()
				turtle.forward()
			end
		end
		turtle.turnLeft()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		turtle.dig()
		turtle.suck()
		turtle.forward()
		
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

vecFromHome = { x = 0, y = 0, z = 0 }

if( findTree(vecFromHome) ) then
	mineTree()
	print('Found tree')
end

returnHome(vecFromHome)