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

function returnHome(vecFromHome)
	print('X from home is ' .. vecFromHome.x)
	print('Z from home is ' .. vecFromHome.z)
	print('Y from home is ' .. vecFromHome.y)
	
	if(vecFromHome.x < 0)
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	while(vecFromHome.x > 0) do
		turtle.forward()
		vecFromHome.x = vecFromHome.x - 1
	end
	
	if(vecFromHome.z < 0)
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	while(vecFromHome.z > 0) do
		turtle.forward()
		vecFromHome.z = vecFromHome.z - 1
	end
end

vecFromHome = { x = 0, y = 0, z = 0 }

if( findTree(vecFromHome) ) then
	print('Found tree')
end

returnHome(vecFromHome)