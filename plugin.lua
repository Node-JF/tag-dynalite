-- Information block for the plugin
--[[ #include "src/info.lua" ]]

Color = {
  White = {255, 255, 255},
  Black = {29, 29, 29},
  LtBlack = {88, 88, 88},
  Gray = {65, 65, 65},
  LtGray = {248, 248, 248},
  DkPurple = {37, 31, 45},
  Teal = {1, 141, 176}
}

Defaults = {
  Font = "Roboto",
  FontSize = 12,
  Color = Color.Gray,
  TextBoxSize = {228, 16},
  StatusSize = {228, 16},
  LabelSize = {90, 16}
}

-- Define the color of the plugin object in the design
function GetColor(props)
  return Color.Teal
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  return string.format("Dynalite\nEnvision Gateway\n[%s]", PluginInfo.Version)
end

-- Optional function used if plugin has multiple pages
PageNames = { "Dashboard", "Configuration" }  --List the pages within the plugin
function GetPages(props)
  local pages = {}
  --[[ #include "src/pages.lua" ]]
  return pages
end

-- Define User configurable Properties of the plugin
function GetProperties()
  --[[ #include "src/properties.lua" ]]
  return props
end

-- Optional function to define pins on the plugin that are not connected to a Control
function GetPins(props)
  local pins = {}
  --[[ #include "src/pins.lua" ]]
  return pins
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
  --[[ #include "src/rectify_properties.lua" ]]
  return props
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "src/controls.lua" ]]
  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout = {}
  local graphics = {}
  --[[ #include "src/layout.lua" ]]
  return layout, graphics
end

--Start event based logic
if Controls then

  -- Constants
  commandQueue = {}
  max_controls = #Controls["area_number"]
  pollTimer, queueTimer = Timer.New(), Timer.New()
  
  --[[ #include "src/runtime/commands.lua" ]]

  --[[ #include "src/runtime/utility_functions.lua" ]]

  if Properties["Connection Type"].Value == "TCP" then

    --[[ #include "src/runtime/connection-type/tcp.lua" ]]

  elseif Properties["Connection Type"].Value == "Serial" then
    
    --[[ #include "src/runtime/connection-type/serial.lua" ]]
  
  end

  --[[ #include "src/runtime/connection-type/both.lua" ]]

  --[[ #include "src/runtime/eventhandlers.lua" ]]

  DisableTcpControls((Properties["Connection Type"].Value == 'Serial'))
  
  Connect()

end
