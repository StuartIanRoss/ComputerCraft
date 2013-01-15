-- MineDemo
--
-- Demo program that mines a block (parses starting position 
-- and dimensions from program args)

function require(file)
  shell.run(file)
end

require("/lib/Vector")
require("/lib/Agent")
require("/lib/Mine")
require("/lib/String")

args = {...}

-- Main function
function main()

  if not (table.getn(args) == 2) then
    print("Usage: MineBlock <Start> <Dimensions>")
    print("(e.g. \"MineBlock 0,0,0 3,3,1\"")
    error()
  end

  -- Parse start and dimension arguments
  start = Vector.parseString(args[1]);
  dim = Vector.parseString(args[2]);

  -- Mine that block!
  print("main: Mining block")
  Mine.block(start,dim.x,dim.y,dim.z)

  -- Clean up
  print("main: Finished, returning to (0,0,0)")
  agent.moveTo(Vector.new(0,0,0))
  agent.turnTo(0)
  
end

main()