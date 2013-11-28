-- libnet
--
-- A library to build a more detailed networking system on top of rednet
-- May ultimately me changed to use the basic modem networking instead of rednet
-- Stuart Ross  - 23/11/2013

local PACKET_TYPE_UDP = 0

_Connection = {}

_Connection.new = function(inputIp)
  local self = {}
  
  -- Default to subnet 0, ip 255 (broadcast), gateway 0
  self._private = {version = 0, ip = inputIp, gateway = {[0]=192,[1]=168,[2]=0,[3]=0,}, openPorts = {}, isRouter = false}
  
  self.setIp = function(ip)
    self._private.ip = ip
  end
  
  self.getIp = function()
    return self._private.ip
  end
  
  self.setGatewayIp = function(gateway)
    self._private.gateway = gateway
  end
  
  self.getSide = function()
    return self._private.side
  end
  
  self.setIsRouter = function(set)
    return self_private.isRouter = set
  end
  
  self.isRouter = function()
    return self._private.isRouter
  end

  -- Wraps the data into an IP packet
  self._private.sendIPPacket = function(packetType, destinationIp, data)
    local ipPacket = {}

    ipPacket.packetType = packetType
    ipPacket.version = self._private.version
    ipPacket.destinationIp = destinationIp
    ipPacket.sourceIp = self._private.ip
    ipPacket.data = textutils.serialize(data)

    -- Need to find routing info to destinationIp to resolve mac address
  end
  
  self._private.sendUDPPacket = function(destinationIp, destinationPort, data)
    local udpPacket = {}
    udpPacket.destinationPort = destinationPort
    udpPacket.data = data
    self._private.sendIPPacket(PACKET_TYPE_UDP, destinationIp, udpPacket) 
  end
  
  self.sendPacket = function(destinationIp, destinationPort, data)
    self._private.sendUDPPacket(destinationIp, destinationPort, data)
  end
  
  self.openPort = function(portNum)
    self._private.openPorts[portNum] = true
  end
  
  self.closePort = function(portNum)
    self._private.openPorts[portNum] = nil
  end
  
  self.isPortOpen = function(portNum)
    self._private.openPorts[portNum] ~= nil
  end
  
  return self
end

-- Main public library functions
_PewNet = {}

_PewNet.new = function()

  local self = {}
  
  self._private = {}
  self._private.openConnections = {}

  self._private.createConnection = function(ip)
    local connection = _Connection.new(ip)
    self._private.openConnections[ip] = connection
  end
  
  self.closeConnection = function(connection)
    if type(connection) ~= "table" then
      print("No valid connection object passed in")
      return
    end

    self._private.openConnections[connection.getIp()] = nil
  end
  
  -- Returns table with ipconfig data
  self.loadIpConfig = function()
    local configDetails = nil
    local handle = fs.open('/etc/_ipconfig','r')
    if handle then
      repeat
        local configLine = handle.readLine()
        if configLine then
          local connDetails = textutils.unserialize(configLine)
        
          if not configDetails then
            configDetails = {}
          end
          configDetails[#configDetails] = connDetails
        end
      until not configLine
      handle.close()
    end
    return configDetails
  end
  
  self.saveIpConfig = function(config)
    local handle = fs.open('/etc/_ipconfig','w')
    if handle then
      for k,v in pairs(config) d
        handle.writeLine( textutils.serialize( v ) )
      end
      handle.close()
    end
  end
  
-- Runs libnet, should be run on a coroutine/parallel (based off rednet run method)
-- This parallel function captures all the incoming packets and pushes them to the correct connection
  self.run = function()
    if bRunning then
      print( "pewnet is already running" )
      return
    end
    print("pewnet is now running")
    bRunning = true
    
    local configs = self.loadIpConfig()
    
    for k,v in pairs(configs) do
      self.createConnection(v.ip)
    end
  
    while bRunning do
      local senderId, message, distance = rednet.receive()
      
      local ipPacket = textutils.unserialize(message)
      
      if self._private.openConnections[ipPacket.destinationIp] ~= nil then
        -- This is an ip packet meant for us
        
        if packet.type == PACKET_TYPE_UDP then
          local udpPacket = ipPacket.payload
        
          if self._private.openConnections[ipPacket.destinationIp].isPortOpen(udpPacket.destinationPort) then
            -- This is a UDP packet for an open port, store it so the app can use it
          else
            print("Ignored UDP packet as port " .. udpPacket.destinationPort .. " is not open for connection " .. ipPacket.destinationIp)
          end
        else
          print("Ignored IP packet as it was of an unknown type")
        end
      else
        print("Ignored IP packet as we are not connection " .. ipPacket.destinationIp)
      end
    end
  end
  
  return self
end

libnet = _PewNet.new()