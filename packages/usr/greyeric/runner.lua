
function require(file)
  shell.run(file)
end

require("/lib/Vector")
require("/lib/Agent")
require("/lib/String")

args = {...}

function main()
	
	if not #args == 2 then
		print("Location and destinations not specified")
		error()
	end
	
	print("Moving to/from...")
	
end

main()
