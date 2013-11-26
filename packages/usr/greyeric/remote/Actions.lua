-- This file contains a set of actions and their associated revese actions
-- Populates action table with set of actions and their inverse actions

-- action 0x00
function returnHome()
	print("Return Home")
	while not stackEmpty() do
		cmd = stackPop()
		actions[cmd]["returnFunc"]()
	end
end

-- action 0x01
function forward()
	print("forward")
end

-- action 0x02
function forwardDig()
	print("forwardDig")
end

-- action 0x03
function backward()
	print("backward")
end

actions = {
	[0x00]={["func"]=returnHome},
	[0x01]={["func"]=forward,["returnFunc"]=backward},
	[0x02]={["func"]=forwardDig,["returnFunc"]=backward},
	[0x03]={["func"]=backward,["returnFunc"]=forward},
}

function performAction(cmd)
	actions[cmd]["func"]()
	if cmd > 0 then -- don't push returnHome command
		stackPush(cmd)
		print "Stack Push"
	end
end
