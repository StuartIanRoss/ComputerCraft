-- Log
-- 
-- Provides a simple logging mechanism

Log = {}

Log.Level = { Debug = 1, Info = 2, Warn = 3, Error = 4 }
Log.LevelString = { "Debug", "Info", "Warn", "Error" }

Log.targets = { { name="Terminal", write=print, level = 1, init=nil } }

-- Write debug level message
Log.debug = function(message) 
  Log._write(Log.Level.Debug,message)
end

-- Write info level message
Log.info = function(message) 
  Log._write(Log.Level.Info,message)
end

-- Write warn level message
Log.warn = function(message) 
  Log._write(Log.Level.Warn,message)
end

-- Write error level message
Log.error = function(message) 
  Log._write(Log.Level.Error,message)
end

-- Write at level
Log._write = function(level, message)

	for i=1,table.getn(Log.targets) do
    
    target = Log.targets[i]
    
    if (level >= target.level) then
    
      target.write(Log.LevelString[level] .. ": \t" .. message)
      
    end name
    
	end

end

-- Add a target to the log targets
Log.addTarget = function(name,writeFunction,level)
  table.insert(Log.targets, { name=name, write=writeFunction, level = level } )
end

-- FileTarget
--
-- Simple file target

Log.FileTarget = {}

Log.FileTarget.new = function(fileName)

  local self = {}  
  self._fileName = fileName
  
  -- Write line to file
  self.write = function(message) 
    h = fs.open(self._fileName, "w")
    h.writeLine(message);
    h.close()
  end 
  
  return self

end

-- "Extension method" for Log to provide easy file target add
Log.addFileTarget(fileName,targetName,level)
  fileTarget = Log.FileTarget.new(fileName)
  Log.addTarget(targetName,fileTarget.write,level)
end