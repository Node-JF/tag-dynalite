-------------------------
----- EventHandlers -----
-------------------------

Controls["ip_address"].EventHandler = Connect
Controls["port"].EventHandler = Connect
Controls["connect"].EventHandler = Connect

queueTimer.EventHandler = Dequeue

  -------------------------------------------------
  -- Variables/Constants for Fader Functionality --
  -------------------------------------------------
  
  area_props = {}
  
  for area = 1, Properties["Area Slots"].Value do
  
    -- set up object for area number control and channel faders
    table.insert(area_props, {
      areaSpamTimer = Timer.New(),
      validPreset = true,
      channelSpamTimers = {},
      canUpdate = {},
      isMovingTimers = {},
      isMoving = {}
    })
    
    if Properties["Enable Logical Channels"].Value == "Yes" then 
      for channel = 1, Properties["Logical Channels"].Value do
        table.insert(area_props[area].channelSpamTimers, Timer.New())
        table.insert(area_props[area].canUpdate, true)
        table.insert(area_props[area].isMovingTimers, Timer.New())
        table.insert(area_props[area].isMoving, false)
      end
    end
    
  end

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

for position, area in ipairs(Controls["area_number"]) do
  
  -- fetch area presets and levels
  area.EventHandler = function()
    
    -- to stop spamming requests if someone is using the mouse to drag the 'zone number' control
    area_props[position].areaSpamTimer.EventHandler = function(t)
      t:Stop()
      area_props[position].validPreset = true
      GetCurrentPresets(area.String, position)
      GetChannelLevels(area.String, position)
    
    end
    
    area_props[position].areaSpamTimer:Start(.5)
  
  end

  -- set up preset recall eventhandlers
  for preset = 1, Properties["Presets"].Value do
  
    Controls[string.format("preset_load_%d", preset)][position].EventHandler = function()
      
      -- is a valid preset state because a preset has been recalled
      
      print(string.format("Position [%s] Preset is Valid", position))
      area_props[position].validPreset = true
      
      Enqueue(Protocol['RecallPreset'][Properties['DyNet Protocol'].Value](preset, area.String, math.floor(Controls[string.format("fade_time_%d", preset)][position].Value * 1000)), 1)
      
      GetCurrentPresets(area.String, position)
      
      GetChannelLevels(area.String, position)
      
    end
  
  end
  
  if (Properties["Enable Logical Channels"].Value == "Yes") then

    -- set up fader eventhandlers
    for channel = 1, Properties["Logical Channels"].Value do
      
      -- don't receive polling updates while fader is moving
      area_props[position].isMovingTimers[channel].EventHandler = function(t)
        t:Stop()
        area_props[position].isMoving[channel] = false
        print(string.format("Area [%s], Channel [%d] is %s", area.String, channel, ((area_props[position].isMoving[channel] == false) and "Listening for Polling Updates" or "Not Available")))
      end

      Controls[string.format("channel_%d", channel)][position].EventHandler = function(ctl)
      
        -- not a valid preset state as the fader has been moved manually
        if (area_props[position].isMoving[channel] == false) then
        
          print(string.format("Position [%s] Preset is Invalid Becase [Manual Logical Channel Adjustment]", position))
          area_props[position].validPreset = false
          
        end
        
        SetPresetLEDs(0, area.String)
        
        -- if cannot update, return here
        if not area_props[position].canUpdate[channel] then return end
          
        area_props[position].canUpdate[channel] = false
        
        area_props[position].isMoving[channel] = true
        
        -- to stop spamming requests when the fader is moved
        area_props[position].channelSpamTimers[channel].EventHandler = function(t)
          t:Stop()
          
          -- get the level value
          local level = math.floor(ctl.Value)
          
          -- write this command directly so there's no delay which would occur by queueing
          Send(Protocol['SetLevel'][Properties['DyNet Protocol'].Value](channel, level, area.String))
          area_props[position].canUpdate[channel] = true
        
          area_props[position].isMovingTimers[channel]:Start(1)
        end
      
        area_props[position].channelSpamTimers[channel]:Start(.2)
      
      end
    end
  end
end