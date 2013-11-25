-- Agent
--
-- Represents the agent, maintains a record of its position 
-- and facing. Starting position is (0,0,0) while facing is 
-- 0 degrees. Instantiates a global at foot of file...
--
-- Provides methods for movement, some need reworking to a 
-- greater or lesser extent. Notable problem with "dig" bool
-- passed not useful anymore.

Agent = {}

Agent.new = function(position)

  local self = {}
  
  position = position or Vector()
  
  -- Public variables
  self.pos = position
  self.ori = 0 -- degrees
  
  -- Move forward
  self.forward = function(n,dig) 

    n = n or 1
    
    -- dig defaults to true
    dig = dig or true
  
    for i=1,n do
    
      local moved = false
    
      while not moved  do
    
        if turtle.detect() then
          turtle.dig()
        end
        
        moved = turtle.forward()
      
      end
      
      self._updateLocation(1)
      
    end

  end

  -- Move up
  self.up = function(n,dig) 
  
    n = n or 1
    
    -- dig defaults to true
    dig = dig or true
  
    for i=1,n do
    
      if dig then
        while turtle.detectUp() do
          turtle.digUp()
        end
      end

      local moved = turtle.up()  
      if moved then self.pos.z = self.pos.z + 1 end
    
    end

  end

  -- Move down
  self.down = function(n,dig)

    n = n or 1
    
    -- dig defaults to true
    dig = dig or true
  
    for i=1,n do

      if dig then
        while turtle.detectDown() do
          turtle.digDown()
        end
      end
    
      local moved = turtle.down()  
      if moved then self.pos.z = self.pos.z - 1 end 

    end  

  end

  -- Turn right
  self.turnRight = function()

    turtle.turnRight()
    self.ori = (self.ori + 90) % 360

  end

  -- Turn left
  self.turnLeft = function()

    turtle.turnLeft()
    self.ori = (self.ori - 90) % 360

  end

  -- Turn to given angle, written in a hurry, please fix
  self.turnTo = function(degrees)

    while not (self.ori == degrees) do
      self.turnLeft()
    end

  end

  -- Update location based on facing and movement self.oriection
  self._updateLocation = function(movement)

    if self.ori == 0 then
      self.pos.y = self.pos.y + movement
    elseif self.ori == 90 then
      self.pos.x = self.pos.x + movement
    elseif self.ori == 180 then
      self.pos.y = self.pos.y - movement
    elseif self.ori == 270 then
      self.pos.x = self.pos.x - movement
    end
          
  end

  -- Dig to the left and do a 180, used for mining
  self.digLeft180 = function()

    self.turnLeft()
    self.forward()
    self.turnLeft()
    
  end

  -- Dig to the right and do a 180, used for mining
  self.digRight180 = function()

    self.turnRight()
    self.forward()
    self.turnRight()

  end

  -- Move by x, y, z
  self.move = function(vec,dig)
    
    -- handle X
    if vec.x > 0 then
      self.turnTo(90)
      self.forward(math.abs(vec.x),dig)
    elseif vec.x < 0 then
      self.turnTo(270)
      self.forward(math.abs(vec.x),dig)
    end
    
    -- handle Y
    if vec.y > 0 then
      self.turnTo(0)
      self.forward(math.abs(vec.y),dig)
    elseif vec.y < 0 then
      self.turnTo(180)
      self.forward(math.abs(vec.y),dig)
    end
      
    -- handle Z
    if vec.z > 0 then
      self.up(math.abs(vec.z),dig)
    elseif vec.z < 0 then
      self.down(math.abs(vec.z),dig)    
    end
    
  end

  -- Move to point
  self.moveTo = function(point,dig)

    vec = point.diff(self.pos);    
    agent.move(vec,dig)

  end
  
  return self

end

-- Instantiate global agent
agent = Agent.new()