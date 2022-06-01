Protocol = {

  ['WhoAreYou'] = {
  
    ['Text'] = "WhoAreYou",
    
    ['2'] = function()
    
    end
    
  },
  
  ['RequestCurrentPresets'] = {
  
    ['Text'] = function(area)
      return string.format("RCP %s", area)
    end,
    
    ['2'] = function(area)
      return GeneratePacket({0x1C, tonumber(area), 0x00, 0x63, 0x00, 0x00, 0xFF})
    end
    
  },
  
  ['RequestCurrentLevels'] = {
  
    ['Text'] = function(channel, area)
      return string.format("RCL %d %s", channel, area)
    end,
    
    ['2'] = function(channel, area)
      return GeneratePacket({0x1C, tonumber(area), tonumber(channel) - 1, 0x61, 0x00, 0x00, 0xFF})
    end
    
  },
  
  ['RecallPreset'] = {
  
    ['Text'] = function(preset, area, fade)
      return string.format("p %s %s %s 255", preset, area, fade)
    end,
    
    ['2'] = function(preset, area, fade)
      local fade = bitstring.pack("16:int", (tonumber(fade) * 0.05))
      local hi, low = fade:sub(1, 1), fade:sub(2, 2)
      
      --print( string.format( "[%X][%X]", string.byte(low), string.byte(hi) ) )
      
      return GeneratePacket({0x1C, tonumber(area), tonumber(preset) - 1, 0x65, string.byte(low), string.byte(hi), 0xFF})
    end
    
  },
  
  ['SetLevel'] = {
  
    ['Text'] = function(channel, level, area)
      return string.format('CL %d %d %d 200 255', channel, level, area)
    end,
    
    ['2'] = function(channel, level, area)
      return GeneratePacket({0x1C, tonumber(area), tonumber(channel) - 1, 0x71, tonumber(level), 0x05, 0xFF})
    end
    
  },
  
}