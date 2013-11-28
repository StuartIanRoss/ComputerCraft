function require(api)
 shell.run('/lib/' .. api)
end

require('libnet')

function run()
  connection = pewnet.openConnection("right")
  if connection then connection.broadcast("hello") end
end

run()
