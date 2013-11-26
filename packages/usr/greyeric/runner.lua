
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
	
	print(a.pos)
	print(B2.diff(myPos))
	
	if (dest == "home") then
		agent.move(B1.diff(myPos))
	else
		agent.move(B2.diff(myPos))
	end
	
end

main()
