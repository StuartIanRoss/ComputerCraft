
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')
require('/lib/libfetch')
--require('/lib/Vector')

function fetchPlan(url)
	return libfetch.fetchContents(url)
end

function runPlan(plan)
	
	pos = 1
	
	while plan[pos] ~= nil do
		if plan[pos] == 0xFF then -- catch quit command
			return true
		else
			performAction(plan[pos])
		end
		pos = pos + 1
	end
	
	return false
end

function postResults(url,data)
	http.post(url,data)
	http.close()
end

function main(args)
	
	if #args == 0 then
		print("Usage: RemoteTest url")
		return
	end
	
	local url = args[1]
	
	while true do
		
		local remoteCallOk,myPlanRaw = pcall(fetchPlan,url)
		
		if remoteCallOk then
			
			local unserializeOk,myPlan = pcall(textutils.unserialize,myPlanRaw)
			
			if myPlanRaw ~= nil and unserializeOk then
				
				local executeOk,executeVal = pcall(runPlan,myPlan)
				
				if executeOk ~= true then
					
					if not performAction(0x00) then -- returnHome
						print("Unable to return home! :(")
						return
					end
					
					print("")
					print("Error:")
					print(val)
					print("")
					
					postResults(url,"actionComplete=false")
				else
					postResults(url,"actionComplete=true")
				end
				
				if executeVal then
					print("Finished")
					return
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