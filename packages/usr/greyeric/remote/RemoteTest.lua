
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

function main(args)
	
	if #args == 0 then
		print("Usage: RemoteTest url")
		return
	end
	
	while true do
		
		local remoteCallOk,myPlanRaw = pcall(fetchPlan,args[1])
		
		if remoteCallOk then
			
			local unserializeOk,myPlan = pcall(textutils.unserialize,myPlanRaw)
			
			if myPlanRaw ~= nil and unserializeOk then
				
				local executeOk,executeVal = pcall(runPlan,myPlan)
				
				if executeOk ~= true then
					
					print("")
					print("Error:")
					print(val)
					print("")
					
					performAction(0x00) -- returnHome
					
				end
			end
		else
			print("Unable to resolve url")
			return
		end
		
		performAction(0xFE) -- wait 1 second between plans
		
	end
	
end

args = {...}
main(args)