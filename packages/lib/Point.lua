-- Point
-- 
-- Describes a "Point" and provides some basic utility methods: 
-- equality, differencing and string to point parsing.

Point = {}

Point.new = function(x,y,z)
	
  local self = {} 
  self.x = x or 0        
  self.y = y or 0   
  self.z = z or 0

  -- Builds a string representation
  self.toString = function()
    return string.format("(%d,%d,%d)", self.x, self.y, self.z)
  end
  
  -- Computes the difference between self and another point
  self.diff = function(point)
  
    x = self.x - point.x
    y = self.y - point.y
    z = self.z - point.z
    
    output = Point.new(x,y,z)
    
    return output
    
  end
  
  -- Checks for equality between self and another point
  self.equal = function(point)
  
    return 
      (
        self.x == point.x and
        self.y == point.y and
        self.z == point.z
      )
    
  end
	
  return self
end

-- Builds a point from a string of format "13,-1,12", useful for program arguments
Point.parseString = function(str)
  
  parts = String.split(str,",")
  
  x = tonumber(parts[1])
  y = tonumber(parts[2])
  z = tonumber(parts[3])
  
  return Point.new(x,y,z)

end