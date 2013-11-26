
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')

function run(plan)
	pos = 1

	while plan[pos] ~= nil do
		performAction(plan[pos])
		pos = pos + 1
	end
end

args = {...}

function main(args)
	
	local myPlan = { 0x01, 0x04, 0xFF, 0xFF, 0xFF, 0x00 }
	local ok,val = pcall(run,myPlan)
	
	if ok ~= true then
		print("Error: "..val)
		performAction(0x00) -- returnHome
	end
	
end

main()