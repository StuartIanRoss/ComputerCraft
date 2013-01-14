-- Vector
-- 
-- Describes a "Vector" and provides some basic utility methods: 
-- equality, differencing and string to vector parsing.

Vector = {}

Vector.new = function(x,y,z)
	
  local self = {} 
  self.y = y or 0   
  self.x = x or 0        
  self.z = z or 0

  -- Builds a string representation
  self.toString = function()
    return string.format("(%d,%d,%d)", self.x, self.y, self.z)
  end
  
  -- Computes the difference between self and another vector
  self.diff = function(vector)
  
    x = self.x - vector.x
    y = self.y - vector.y
    z = self.z - vector.z
    
    output = Vector.new(x,y,z)
    
    return output
    
  end
  
  -- Checks for equality between self and another vector
  self.equal = function(vector)
  
    return 
      (
        self.x == vector.x and
        self.y == vector.y and
        self.z == vector.z
      )
    
  end
	
  return self
end

-- Builds a vector from a string of format "13,-1,12", useful for program arguments
Vector.parseString = function(str)
  
  parts = String.split(str,",")
  
  x = tonumber(parts[1])
  y = tonumber(parts[2])
  z = tonumber(parts[3])
  
  return Vector.new(x,y,z)

end