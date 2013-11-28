function require(api)
 shell.run('/lib/' .. api)
end

require('libnet')

function run()
-- Connect printer
--  local printer = peripheral.wrap("left")
--  printer.newPage()
-- Connect monitor
  local monitor = peripheral.wrap("top")
  monitor.clear()
  monitor.setCursorPos(1,1)

  print("Opening connection")
  local connection = libnet.getDefaultConnection()
  while connection do
    print("Waiting for message")
    local message = connection.receive(1)
    if message then
--      printer.write(message)
--      local maxx, maxy = printer.getPageSize()
--      local oldx, oldy = printer.getCursorPos()
--      if (oldy + 1) > maxy then
--        printer.endPage()
--        printer.newPage()
--      else
--        printer.setCursorPos(1,oldy+1)
--      end
      
      monitor.write(textutils.unserialize(message))
      local oldx, oldy = monitor.getCursorPos()
      monitor.setCursorPos(1,oldy+1)
      local maxx, maxy = monitor.getPageSize()
      if (oldy + 1) > maxy then
        monitor.scroll(1)
      end
    else
      print("Timeout")
    end
  end
end

parallel.waitForAny( 
		function()
			run()
		end,
		function()
			pewnet.run()
		end )