Protocol = {

  ['WhoAreYou'] = {
  
    ['DyNet Text'] = "WhoAreYou",
    
    ['DyNet 1'] = function()
    
    end
    
  },
  
  ['RequestCurrentPresets'] = {
  
    ['DyNet Text'] = function(area) -- can i do join values with dynet text?
      return string.format("RCP %s", area)
    end,
    
    ['DyNet 1'] = function(area, join)
      return GeneratePacket({0x1C, tonumber(area), 0x00, 0x63, 0x00, 0x00, join})
    end
    
  },
  
  ['RequestCurrentLevels'] = {
  
    ['DyNet Text'] = function(channel, area)
      return string.format("RCL %d %s", channel, area)
    end,
    
    ['DyNet 1'] = function(channel, area, join)
      return GeneratePacket({0x1C, tonumber(area), tonumber(channel) - 1, 0x61, 0x00, 0x00, join})
    end
    
  },
  
  ['RecallPreset'] = {
  
    ['DyNet Text'] = function(preset, area, fade)
      return string.format("p %s %s %s 255", preset, area, fade)
    end,
    
    ['DyNet 1'] = function(preset, area, fade, join)
      local fade = bitstring.pack("16:int", (tonumber(fade) * 0.05))
      local hi, low = fade:sub(1, 1), fade:sub(2, 2)

      if(Properties['Preset Recall Mode'].Value == 'Linear') then 
        return GeneratePacket({0x1C, tonumber(area), tonumber(preset) - 1, 0x65, string.byte(low), string.byte(hi), join})
      end
      
      --print( string.format( "[%X][%X]", string.byte(low), string.byte(hi) ) )
      local opcodes = {
        0x00,
        0x01,
        0x02,
        0x03,
        0x0A,
        0x0B,
        0x0C,
        0x0D
      }
      
      -- preset = preset - 1
      local opcode
      local offset
      local divisions = math.floor(preset / 8)
      
      opcode = preset - (divisions * 8)
      
      if (opcode == 0) then 
        opcode = 8
        offset = divisions - 1
      else 
        offset = divisions
      end 

      opcode = opcodes[opcode]

      return GeneratePacket({0x1C, tonumber(area), string.byte(low), opcode, string.byte(hi), offset, join})
      
    end
    
  },
  
  ['SetLevel'] = {
  
    ['DyNet Text'] = function(channel, level, area)
      return string.format('CL %d %d %d 200 255', channel, level, area)
    end,
    
    ['DyNet 1'] = function(channel, level, area, join)
      return GeneratePacket({0x1C, tonumber(area), tonumber(channel) - 1, 0x71, tonumber(level), 0x05, join})
    end
    
  },
  
}