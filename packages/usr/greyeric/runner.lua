
function require(file)
  shell.run(file)
end

require("/lib/Vector")
require("/lib/Agent")
require("/lib/String")

args = {...}

B1 = Vector.parseString("-45,72,-131")
B2 = Vector.parseString("-50,72,-131")

function main()
	
	if #args == 0 then
		print("Location and destinations not specified")
		error()
	end
	
	local myPos = Vector.parseString(args[1])
	local height = 250
	
	local dest = args[2]
	
	a = Agent(myPos)
	
	if (dest == "home") then
		a.move(B1)
	else
		a.move(B2)
	end
	
end

main()
