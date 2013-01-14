-- Mine
-- 
-- Limited selection of mining methods

Mine = {}

-- Mine a layer given an origin, x (width) and y (depth)
Mine.layer = function(origin,x,y)

  print("layer: "..origin.toString()..", "..x..", "..y)
      
  agent.moveTo(origin)
  agent.turnTo(0)
      
  for i=1,x do
  
    agent.forward(y-1)
    
    if not (i == x) then
      if i % 2 == 0 then
        agent.digLeft180()
      else
        agent.digRight180()
      end
    end
  
  end
  
  print("layer: Finished")
              
end

-- Mine a block given an origin and dimensions
Mine.block = function(origin,x,y,z)

  print("block: "..origin.toString()..", "..x..", "..y..", "..z.."")
  
  agent.moveTo(origin)
  agent.turnTo(0)

  for i=1,z do
  
    print("block: Mining layer "..i)
    Mine.layer(origin.diff(Point.new(0,0,i-1)),x,y)
    agent.turnTo(0)
  
  end
  
  print("block: Finished block")

end