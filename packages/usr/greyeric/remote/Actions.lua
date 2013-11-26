-- This file contains a set of actions and their associated revese actions
-- Populates action table with set of actions and their inverse actions

-- action 0x00
function returnHome()
	print("Return Home")
	while not stackEmpty() do
		cmd = stackPop()
		if cmd ~= nil and actions[cmd]["returnFunc"] ~= nil then
			actions[cmd]["returnFunc"]()
		end
	end
end

-- action 0x01
function forward()
	print("forward")
	turtle.forward()
end

-- action 0x02
function forwardDig()
	print("forwardDig")
	while not turtle.forward() do
		turtle.dig()
	end
end

-- action 0x03
function backward()
	print("backward")
	turtle.back()
end

-- action 0x04
function up()
	print("up")
	turtle.up()
end

-- action 0x05
function down()
	print("down")
	turtle.down()
end

-- action 0x06
function left()
	print("turn left")
	turtle.turnLeft()
end

-- action 0x07
function right()
	print("turn right")
	turtle.turnRight()
end

-- action 0x08
function dig()
	print("dig")
	turtle.dig()
end

-- action 0x09
function digUp()
	print("dig up")
	turtle.digUp()
end

-- action 0x0A
function digDown()
	print("dig down")
	turtle.digDown()
end



-- action 0xFE
function noop()
	print("noop")
	os.sleep(1)
end

-- action 0xFF
function forceQuit()
	print("quit")
end

actions = {
	[0x00]={["func"]=returnHome},
	[0x01]={["func"]=forward,["returnFunc"]=backward},
	[0x02]={["func"]=forwardDig,["returnFunc"]=backward},
	[0x03]={["func"]=backward,["returnFunc"]=forward},
	[0x04]={["func"]=up,["returnFunc"]=down},
	[0x05]={["func"]=down,["returnFunc"]=up},
	[0x06]={["func"]=left,["returnFunc"]=right},
	[0x07]={["func"]=right,["returnFunc"]=left},
	[0x08]={["func"]=dig,["returnFunc"]=nil},
	[0x09]={["func"]=digUp,["returnFunc"]=nil},
	[0x0A]={["func"]=digDown,["returnFunc"]=nil},
	
	[0xFE]={["func"]=noop,["returnFunc"]=nil},
	[0xFF]={["func"]=forceQuit,["returnFunc"]=nil},
}

function performAction(cmd)
	actions[cmd]["func"]()
	if cmd > 0 then -- don't push returnHome command
		stackPush(cmd)
	end
end
