-- Vector
-- 
-- Describes a "Vector" and provides some basic utility methods: 
-- equality, differencing and string to vector parsing.

Vector = {}

Vector.new = function(x,y,z)
	
  local self = vector.new()

  -- Builds a string representation
  self.toString = function()
    return self:tostring()
  end
  
  -- Computes the difference between self and another vector
  self.diff = function(vec)
    return self:sub(vec)
  end
  
  -- Checks for equality between self and another vector
  self.equal = function(vec)  
    return 
      (
        self.x == vec.x and
        self.y == vec.y and
        self.z == vec.z
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