-- libnet
--
-- A library to build a more detailed networking system on top of rednet
-- May ultimately me changed to use the basic modem networking instead of rednet
-- Stuart Ross  - 23/11/2013

local PACKET_TYPE_UDP = 0

_Connection = {}

_Connection.new = function(inputIp, gatewayIp, connSide)

  if not peripheral.isPresent(connSide) or peripheral.getType(connSide) ~= "modem" then
    print("Modem not found on side " .. connSide)
    return nil
  end
  rednet.open(connSide)
  local self = {}
  
  -- Default to subnet 0, ip 255 (broadcast), gateway 0
  self._private = {version = 0, side = connSide, ip = inputIp, gateway = gatewayIp, openPorts = {}, isRouter = false}
  
  self.setIp = function(ip)
    self._private.ip = ip
  end
  
  self.getIp = function()
    return self._private.ip
  end
  
  self.setGatewayIp = function(gateway)
    self._private.gateway = gateway
  end
  
  self.getBroadcastIp = function()
    local broadcastIp = {}
    broadcastIp[0] = self._private.ip[0]
    broadcastIp[1] = self._private.ip[1]
    broadcastIp[2] = self._private.ip[2]
    broadcastIp[3] = 255
    return broadcastIp
  end
  
  self.setIsRouter = function(set)
    self._private.isRouter = set
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
    
    -- Broadcast
    if destinationIp[3] == 255 then
      print("Broadcasting packet over rednet")
      rednet.broadcast(textutils.serialize(ipPacket))
    else
      print("Not a broadcast packet, so currently ignored")
    end
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
  
  self.broadcast = function(data)
    self._private.sendUDPPacket(self.getBroadcastIp(),65535,data)
  end
  
  self.receive = function(timeout)
    local timer = nil
    local sFilter = nil
    if nTimeout then
      timer = os.startTimer( nTimeout )
      sFilter = nil
    else
      sFilter = "pewnet_message"
    end
    while true do
      local e, p1, p2, p3, p4, p5 = os.pullEvent( sFilter )
      if e == "pewnet_message" then
        local sMessage = p1, p2, p3
        return sMessage
      elseif e == "timer" and p1 == timer then
        return nil
      end
    end	
  end
  
  self.openPort = function(portNum)
    self._private.openPorts[portNum] = true
  end
  
  self.closePort = function(portNum)
    self._private.openPorts[portNum] = nil
  end
  
  self.isPortOpen = function(portNum)
    return self._private.openPorts[portNum] ~= nil
  end
  
  -- Open a port to receive broadcast data
  self.openPort(65535)
  
  return self
end

-- Main public library functions
_PewNet = {}

_PewNet.new = function()

  local self = {}
  
  self._private = {}
  self._private.openConnections = {}

  self._private.createConnection = function(ip, gateway, side)
    local connection = _Connection.new(ip, gateway, side)
    self._private.openConnections[#self._private.openConnections] = connection
  end
  
  self.getDefaultConnection = function()
    return self._private.openConnections[0]
  end
  
  self.sendPacket = function(destinationIp, destinationPort, data)
    if self._private.openConnections[0] then
      self._private.openConnections[0].sendPacket(destinationIp, destinationPort, data)
    else
      print("No open connection found.")
    end
  end
  
  self.broadcast = function(data)
    if self._private.openConnections[0] then
      self._private.openConnections[0].broadcast(data)
    else
      print("No open connection found.")
    end
  end
  
  self.doIpsMatch = function(check1, check2)
    return (check1[0] == check2[0]) and (check1[1] == check2[1]) and (check1[2] == check2[2]) and (check1[3] == check2[3])
  end
  
  self.closeConnection = function(connection)
    if type(connection) ~= "table" then
      print("No valid connection object passed in")
      return
    end
    
    for k,v in ipairs(self._private.openConnections) do
      if v and v.isThisIp(connection.getIp()) then
        self._private.openConnections[k] = nil
      end
    end
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
      for k,v in pairs(config) do
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
  
    while bRunning do
      local senderId, message, distance = rednet.receive()
      
      local ipPacket = textutils.unserialize(message)
      
      local destConnection = nil
      
      for k,v in ipairs(self._private.openConnections) do
        if v and (self.doIpsMatch(v.getIp(),ipPacket.destinationIp) or self.doIpsMatch(v.getBroadcastIp(),ipPacket.destinationIp)) then
          destConnection = v
        end
      end
      
      if destConnection ~= nil then
        -- This is an ip packet meant for us
        
        if packet.type == PACKET_TYPE_UDP then
          local udpPacket = ipPacket.payload
        
          if destConnection.isPortOpen(udpPacket.destinationPort) then
            -- This is a UDP packet for an open port, store it so the app can use it
            print("Queing message")
            os.queueEvent( "pewnet_message", ipPacket )
          else
            print("Ignored UDP packet as port " .. udpPacket.destinationPort .. " is not open for connection " .. textutils.serialize(ipPacket.destinationIp))
          end
        else
          print("Ignored IP packet as it was of an unknown type")
        end
      else
        print("Ignored IP packet as we are not connection " .. textutils.serialize(ipPacket.destinationIp))
      end
    end
  end
  
   -- Setup all connections
  local configs = self.loadIpConfig()
  
  if configs ~= nil then
    for k,v in pairs(configs) do
      self._private.createConnection(v.ip, v.gateway, v.side)
    end
  end
  
  return self
end

libnet = _PewNet.new()