
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
	
	local B1Diff = Vector(B1.x - myPos.x, B1.y - myPos.y, B1.z - myPos.z)
	local B2Diff = Vector(B2.x - myPos.x, B2.y - myPos.y, B2.z - myPos.z)
	
	if (dest == "home") then
		Agent.move(B1Diff)
	else
		Agent.move(B2Diff)
	end
	
end

main()
