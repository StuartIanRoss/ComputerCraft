
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')
require('/lib/libfetch')

function fetchPlan(url)
	return { 0x01, 0x04, 0xFF, 0xFF, 0xFF, 0x00 }
end

function runPlan(plan)
	pos = 1

	while plan[pos] ~= nil do
		performAction(plan[pos])
		pos = pos + 1
	end
end

args = {...}

function main(args)
	
	local myPlan = fetchPlan("abc")
	local ok,val = pcall(runPlan,myPlan)
	
	if ok ~= true then
		
		print("")
		print("Error:")
		print(val)
		print("")
		
		performAction(0x00) -- returnHome
		
	end
	
end

main()