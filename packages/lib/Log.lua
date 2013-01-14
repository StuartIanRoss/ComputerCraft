-- Log
-- 
-- Provides a simple logging mechanism

Log = {}

Log.Level = { Debug = 0, Info = 1, Warn = 2, Error = 3 }

Log.targets = { { name="Terminal", print=print, level=0 } }

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

	for (i=1,table.getn(Log.targets)) do
    
    target = Log.targets[i]
    
    if (level > target.level) then
    
      target.print(message)
      
    end
    
	end

end