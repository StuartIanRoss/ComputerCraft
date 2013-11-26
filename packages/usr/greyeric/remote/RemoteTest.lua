
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')
require('/lib/libfetch')

function fetchPlan(url)
	return libfetch.fetchContents(url)
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
	
	if #args == 0 then
		print("Usage: RemoteTest url")
		return
	end
	
	while true do
	
		local myPlan = fetchPlan("abc")
		
		if myPlan ~= nil then
			
			local ok,val = pcall(runPlan,myPlan)
			
			if ok ~= true then
				
				print("")
				print("Error:")
				print(val)
				print("")
				
				performAction(0x00) -- returnHome
				
			end
		end
	end
	
end

main()