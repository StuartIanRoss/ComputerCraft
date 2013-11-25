
function require(file)
  shell.run(file)
end

require("/lib/Vector")
require("/lib/Agent")
require("/lib/String")

args = {...}

function main()
	
	local B1 = Vector.parseString("-45,72,-131")
	local B2 = Vector.parseString("-50,72,-131")
	
	if #args == 0 then
		print("Location and destinations not specified")
		error()
	end
	
	local myPos = Vector.parseString(args[1])
	local height = 250
	
	local dest = args[2]
	
	a = Agent.new(myPos)
	
	if (dest == "home") then
		a.moveTo(B1)
	else
		a.moveTo(B2)
	end
	
end

main()
