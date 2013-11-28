function require(api)
 shell.run('/lib/' .. api)
end

require('libnet')

function run()
  libnet.broadcast("hello")
end

run()
