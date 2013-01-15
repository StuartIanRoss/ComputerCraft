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
      
    end
    
	end

end

Log.FileTarget = {}

Log.FileTarget.new = function()

  local self = {}
  
  return self

end