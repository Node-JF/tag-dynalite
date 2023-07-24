-------------------
----- Polling -----
-------------------

function Begin()

  Poll()
          
  queueTimer:Start(0)
  
  if Properties["Enable Polling"].Value == "Yes" then pollTimer:Start(Properties["Poll Rate (s)"].Value) end

end

function Poll()
  
  print("User.Info: Polling...")

  --Enqueue('WhoAreYou')
  
  for i = 1, Properties["Area Slots"].Value do
    GetCurrentPresets(Controls['area_number'][i].String, i)
    
    GetChannelLevels(Controls['area_number'][i].String, i)
  end
  
end; pollTimer.EventHandler = Poll

function Enqueue(cmd, position)
  if not position then return table.insert(commandQueue, cmd) end
  table.insert(commandQueue, position, cmd)
  if (position == 1) then queueTimer:Start(0) end
end

----------------------------
----- Helper Functions -----
----------------------------

function SetStatus(value, string)

  Controls["device_status"].Value = value and value or Controls["device_status"].Value
  Controls["device_status"].String = string and string or Controls["device_status"].String
  
end

function GeneratePacket(tbl)
  
  local sum, command = 0, ""
  
  -- sum the table
  for i, byte in ipairs(tbl) do
    sum = sum + byte
  end
  
  -- pack to 8 bit signed integer
  sum = bitstring.pack("8:int", sum)
  
  -- convert to binary stream
  local bin = bitstring.binstream(sum)
  
  local new_bin = ""
  
  -- invert the binary stream
  for i = 1, bin:len() do
  
    local bit = bin:sub(i, i)
    local new_bit
    
    if bit == "0" then
      new_bit = "1"
    elseif bit == "1" then
      new_bit = "0"
    end
    
    new_bin = new_bin .. new_bit
  end
  
  -- add 1, then pack to 8 bit signed integer again
  local checksum = bitstring.pack("8:int", string.byte( bitstring.frombinstream(new_bin) ) + 1 )
  
  -- add it to the command
  table.insert(tbl, string.byte(checksum))
  
  -- print(require('rapidjson').encode(tbl, { pretty = true }))
  
  return tbl
end



function GetPositionsFromArea(area, join) -- update this to also accept a join value and match to that
  
  local tbl = {}

  -- bitmatch the join values
  local function matchJoinValues(configuredJoin, receivedJoin) 
    if not receivedJoin then return true end -- if no received join, just return true so it only matches the area value
    local configuredJoinBits = bitstring.binstream( bitstring.pack('8:int', configuredJoin) )
    local receivedJoinBits = bitstring.binstream( bitstring.pack('8:int', receivedJoin) )
    print( string.format('Matching Join Bits: [%s] to [%s]', receivedJoinBits, configuredJoinBits) )
    for i = 1, 8 do
      if string.sub(configuredJoinBits, i, i) == '1' and string.sub(receivedJoinBits, i, i) == '1' then
        print( string.format('Matched at Bit [%d]', i) )
        return true
      end
    end
    return false
  end
  
  for i, ctl in ipairs(Controls["area_number"]) do
    
    if ( math.floor(ctl.Value) == tonumber(area) ) and matchJoinValues(area_props[i].join, join) then
      table.insert(tbl, i)
    end
  end
  
  return tbl
  
end

function SetPresetLEDs(preset, area, join)

  if (preset ~= 0) then print(string.format("Area [%s], is Updating to Preset [%d]", area, preset)) end
  
  -- get control positions for this area
  positions = GetPositionsFromArea(area, join)
    
  -- for all returned positons, do;
  for _, position in ipairs(positions) do
    
    -- iterate vertically through the preset LED controls
    for i = 1, Properties["Presets"].Value do
      
      -- set the preset true if it matches, else false
      Controls[string.format("preset_match_%d", i)][position].Boolean = ((i == tonumber(preset)) and area_props[position].validPreset == true)
      
    end
  end
end

function UpdateActiveChannels(channel, area, target, current, join)

  if (Properties["Enable Logical Channels"].Value == "No") then return end

  -- get control positions for this area
  positions = GetPositionsFromArea(area, join)
  
  channel = tonumber(channel)
  
  -- for all returned positons, do;
  for _, position in ipairs(positions) do
  
    print(string.format("Area [%s], Channel [%d] is %s", area, channel, ((area_props[position].isMoving[channel] == false) and string.format("Updating to Target [%d]", target) or "Not Available for Updates")))
    
    if area_props[position].isMoving[channel] == false then
    
      -- set the channel level for the incoming channel
      Controls[string.format("channel_%d", channel)][position].String = target
    
    end
  end
end

function AreaIsDuplicate(area, position)
  matches = 0
  for i, c in ipairs(Controls['area_number']) do
    if (c.String == area and area_props[i].join == area_props[position].join) then matches = matches + 1 end
    if (matches > 1) then return true end
  end
  return false
end



------------------------
----- API Requests -----
------------------------

function GetCurrentPresets(area, position)
  
  Controls['area_status'][position].Value = (tonumber(area) == 0) and 3 or 0
  Controls['area_status'][position].String = (tonumber(area) == 0) and "Area Undefined" or ""
  
  
  if (tonumber(area) == 0) then
  
    Controls['area_status'][position].Value = 3
    Controls['area_status'][position].String = "Area Undefined"
    
    return
    
  elseif AreaIsDuplicate(area, position) then
    
    Controls['area_status'][position].Value = 1
    Controls['area_status'][position].String = "Area is Duplicate"
    
  end
  
  print(string.format("Getting Preset for Area [%s]", area and area or "-"))
  
  Enqueue(Protocol['RequestCurrentPresets'][Properties['Protocol'].Value](area, area_props[position].join))
  
end

function GetChannelLevels(area, position)
  
  if Properties["Enable Logical Channels"].Value == "No" then return end 

  if (tonumber(area) == 0) then return end
  
  print(string.format("Getting Channel Levels for Area [%s]", area and area or "-"))
  
  for ch = 1, Properties["Logical Channels"].Value do
    
    Enqueue(Protocol['RequestCurrentLevels'][Properties['Protocol'].Value](ch, area, area_props[position].join))
  end
  
end

function ParseData(data)
  
  local hex = ""
  
  for i = 1, data:len() do
    hex = hex .. string.format("[%02X]", string.byte(data:sub(i, i)))
  end
  
  if (not data) then return end
  
  if (isDyNetText) then
    
    --print(string.format("Data:%s", data))
    
    if data:find("Telnet Connection Established") then
      
      Enqueue('ReplyOK 0')
      Enqueue('Echo 0')
      Enqueue('WhoAreYou')
      Enqueue('Verbose')
      
      Begin()
      
    return end
    
    --if not (line == "") then print(string.format("Sock.Data: '%s'", line)) end
    
    --[[device = line:match("I am (%w+)")
    if device then Controls["device_type"].String = device end]]
    
    --[[box = line:match("Box (%w+)")
    if box then Controls["box"].String = box end]]
    
    --[[version = line:match(", v([%w,]+)")
    if version then Controls["version"].String = version:gsub(",", ".") end]]
    
    preset, area = data:match("Reply with Current Preset (%d+), Area (%d+)")
    if (preset and area) then SetPresetLEDs(preset, area) end
      
    channel, area, target, current = data:match("Reply with Current Level Ch (%w+), Area (%d+), TargLev (%d+)%%, CurrLev (%d+)%%")
    if (channel and area and target and current) then UpdateActiveChannels(channel, area, target, current) end
    
  else
  
    print(string.format("Data:%s", hex))
  
    if (string.byte(data:sub(1, 1)) == 0xAC) then -- dynet 2 response
    
      if (string.byte(data:sub(2, 2)) == 0x03) then
      
        local area = string.byte(data:sub(8, 8))
        local preset = string.byte(data:sub(12, 12))
        -- local join = string.byte(data:sub(9, 9))
        
        SetPresetLEDs(preset, area)
        
      elseif (string.byte(data:sub(2, 2)) == 0x07) then
      
        local area = string.byte(data:sub(8, 8))
        local channel = string.byte(data:sub(12, 12))
        local target = string.byte(data:sub(16, 16))
        
        -- convert to fader range
        target = (((target - 0) * (0 - 255)) / (254 - 0)) + 255
        
        target = math.floor(target)
        
        --print(target)
        
        UpdateActiveChannels(channel, area, target, current)
        
      end
    
    elseif (string.byte(data:sub(1, 1)) == 0x1C) then -- dynet 1 logical response
      
      local opcode = string.byte(data:sub(4, 4))
      local area = string.byte(data:sub(2, 2))
      local join = string.byte(data:sub(7, 7))

      if (opcode == 0x60) then
      
        local channel = string.byte(data:sub(3, 3)) + 1
        local target = string.byte(data:sub(5, 5))
        
        -- convert to fader range
        -- target = (((target - 0) * (0 - 255)) / (254 - 0)) + 255
        
        -- target = math.floor(target)
        
        UpdateActiveChannels(channel, area, target, current, join)
        
      elseif (opcode == 0x62) then

        local preset = string.byte(data:sub(3, 3)) + 1
        
        SetPresetLEDs(preset, area, join)
        
      end

    end
  end
  
end