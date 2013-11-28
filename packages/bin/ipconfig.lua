function require(api)
 shell.run('/lib/' .. api)
end

require('libnet')

local configs = libnet.loadIpConfig()

local gateway = nil
local ip = nil
if configs ~= nil then 
  gateway = configs[0].gateway
  ip = configs[0].ip
else
  configs = {}
end

bool enterGateway = false
if gateway ~= nil then
  print("Current gateway is " .. gateway[0] .. "." .. gateway[1] .. "." .. gateway[2] .. "." .. gateway[3])
else
  print("No gateway currently set.")
  gateway = {}
  enterGateway = true
end

if enterGateway then
  print("Enter gateway in 4 parts")
  local value = io.read()
  gateway[0] = value
  value = io.read()
  gateway[1] = value
  value = io.read()
  gateway[2] = value
  value = io.read()
  gateway[3] = value
end

bool enterIp = false
if ip ~= nil then
  print("Current ip is " .. ip[0] .. "." .. ip[1] .. "." .. ip[2] .. "." .. ip[3])
else
  print("No ip currently set.")
  enterIp = true
end

if enterIp then
  print("Enter gateway in 4 parts")
  local value = io.read()
  ip[0] = value
  value = io.read()
  ip[1] = value
  value = io.read()
  ip[2] = value
  value = io.read()
  ip[3] = value
end


configs[0].gateway = gateway
configs[0].ip = ip
libnet.saveIpConfig(configs)