
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
		
		local remoteCallOk,myPlan = pcall(fetchPlan,args[1])
		
		if remoteCallOk then
			
			if myPlan ~= nil then
				
				local executeOk,executeVal = pcall(runPlan,myPlan)
				
				if executeOk ~= true then
					
					print("")
					print("Error:")
					print(val)
					print("")
					
					performAction(0x00) -- returnHome
					
				end
			end
		end
	end
	
end

main(args)