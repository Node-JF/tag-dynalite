local max_width, max_depth = 318, 300

local page_index = props["page_index"].Value
local count = props["Area Slots"].Value

table.insert(graphics, {
    Type = "Image",
    Image = "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",
    Position = {0, 0},
    Size = {max_width, 144}
})

-------------------------
----- Configuration -----
-------------------------

table.insert(graphics, {
    Type = "Header",
    Text = "DEVICE CONFIGURATION",
    Size = {max_width, 16},
    Position = {0, 164},
    Font = "Roboto",
    FontSize = 13,
    FontStyle = "Light"

})

table.insert(graphics, {
    Type = "Label",
    Text = "IP Address",
    Size = Defaults.LabelSize,
    Position = {0, 186},
    HTextAlign = "Left",
    FontSize = Defaults.FontSize
})

table.insert(graphics, {
    Type = "Label",
    Text = "Port",
    Size = Defaults.LabelSize,
    Position = {0, 206},
    HTextAlign = "Left",
    FontSize = Defaults.FontSize
})

table.insert(graphics, {
  Type = "Label",
  Text = (props['Connection Type'].Value == "Serial") and "TCP Controls Disabled" or (props['Protocol'].Value == "DyNet Text") and "DyNet Text Uses Port 23" or "Default Server Port is 50000",
  Size = {Defaults.TextBoxSize[1] - 36, 16},
  Position = {Defaults.LabelSize[1] + 36, 206},
  HTextAlign = "Center",
  Font = "Roboto",
  FontSize = 10,
  FontStyle = "Italic"
}) 

table.insert(graphics, {
    Type = "Label",
    Text = "Device Status",
    Size = Defaults.LabelSize,
    Position = {0, 226},
    HTextAlign = "Left",
    FontSize = Defaults.FontSize
})

table.insert(graphics, {
    Type = "Label",
    Text = "Connect",
    Size = Defaults.LabelSize,
    Position = {0, 246},
    HTextAlign = "Left",
    FontSize = Defaults.FontSize,
})

layout["ip_address"] = {
    PrettyName = "Device~IP Address",
    Style = "Text",
    TextBoxStyle = "Normal",
    Size = Defaults.TextBoxSize,
    Position = {max_width-Defaults.TextBoxSize[1], 186}
}

layout["port"] = {
  PrettyName = "Device~Port",
  Style = "Text",
  TextBoxStyle = "Normal",
  Size = {36, 16},
  Position = {max_width-Defaults.TextBoxSize[1], 206}
}

layout["device_status"] = {
    PrettyName = "Device~Status",
    Style = "Text",
    TextBoxStyle = "Normal",
    IsReadOnly = true,
    Size = Defaults.StatusSize,
    Position = {max_width-Defaults.StatusSize[1], 226}
}

layout["connect"] = {
    PrettyName = "Device~Connect",
    Style = "Button",
    ButtonStyle = "Toggle",
    Position = {Defaults.LabelSize[1], 246},
    Color = {0, 159, 60}
}

-------------------------
----- Area Controls -----
-------------------------

local starting_depth = 262

table.insert(graphics, {
    Type = "Header",
    Text = "SLOT CONFIGURATION",
    Size = {max_width, 16},
    Position = {0, starting_depth},
    Font = "Roboto",
    FontSize = 13,
    FontStyle = "Light"
})

table.insert(graphics, {
    Type = "Label",
    Text = "Area",
    Size = Defaults.LabelSize,
    Position = {0, starting_depth + 22},
    HTextAlign = "Left",
    Font = Defaults.Font,
    FontSize = Defaults.FontSize,
})

layout[string.format("area_number %d", page_index)] = {
    PrettyName = string.format("Area Slot %d~Number", page_index),
    Style = "Text",
    TextBoxStyle = "Normal",
    Size = {36, 16},
    Position = {Defaults.LabelSize[1], starting_depth + 22},
}

layout[string.format("area_status %d", page_index)] = {
  PrettyName = string.format("Area Slot %d~Status", page_index),
  Style = "Text",
  --IndicatorType = "Status",
  Size = {Defaults.StatusSize[1] - 41, 16},
  Position = {Defaults.LabelSize[1] + 41, starting_depth + 22},
}

if props["Protocol"].Value == "DyNet 1" then
    table.insert(graphics, {
        Type = "Label",
        Text = "Join",
        Size = Defaults.LabelSize,
        Position = {0, starting_depth + 42},
        HTextAlign = "Left",
        Font = Defaults.Font,
        FontSize = Defaults.FontSize,
    })

    for byte = 0, 7 do
        layout[string.format("join_byte_%s %d", byte, page_index)] = {
            PrettyName = string.format("Area Slot %d~Join Byte %s", page_index, byte),
            Style = "Text",
            TextBoxStyle = "Normal",
            Size = {20, 16},
            Position = {Defaults.LabelSize[1] + (byte * 22), starting_depth + 42},
        }
    end

    layout[string.format("join_hex %d", page_index)] = {
        PrettyName = string.format("Area Slot %d~Join Hex", page_index),
        Style = "Text",
        TextBoxStyle = "Normal",
        Color = {194, 194, 194},
        IsReadOnly = true,
        Size = {52, 16},
        Position = {Defaults.LabelSize[1] + (8 * 22), starting_depth + 42},
    }
end

-- table.insert(graphics, {
--     Type = "Label",
--     Text = "Default Join ID is 255",
--     Size = {Defaults.TextBoxSize[1] - 36, 16},
--     Position = {Defaults.LabelSize[1] + 36, starting_depth + 42},
--     HTextAlign = "Center",
--     Font = "Roboto",
--     FontSize = 10,
--     FontStyle = "Italic"
-- }) 

local alt = true
local x = 0

table.insert(graphics, {
    Type = "Svg",
    Image = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEtLSBHZW5lcmF0b3I6IEFkb2JlIElsbHVzdHJhdG9yIDE4LjEuMSwgU1ZHIEV4cG9ydCBQbHVnLUluIC4gU1ZHIFZlcnNpb246IDYuMDAgQnVpbGQgMCkgIC0tPg0KPHN2ZyB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB2aWV3Qm94PSIwIDAgMTQuNzA3IDE0LjcwNyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMTQuNzA3IDE0LjcwNzsiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KPGc+DQoJPHJlY3QgeD0iNi4yNzUiIHk9IjAiIHN0eWxlPSJmaWxsOiMwMzAxMDQ7IiB3aWR0aD0iMi4xNTgiIGhlaWdodD0iMTQuNzA3Ii8+DQo8L2c+DQoNCjwvc3ZnPg0K",
    Position = {max_width , 0},
    Size = {20, max_depth}
})

for preset = 1, props["Presets"].Value do

    x = (max_width + 20) + (math.floor((preset-1)/10) *  (max_width/2))
    y = ((max_depth/10) * (preset-1)) - (max_depth * (math.floor((preset-1)/10)))

    table.insert(graphics, 1, {
        Type = "Label",
        Text = string.format("P %d", preset),
        Size = {(max_width/2), max_depth/10},
        Position = {x, y},
        HTextAlign = "Left",
        Font = Defaults.Font,
        FontSize = Defaults.FontSize,
        Fill = alt and {0, 0, 0, 0} or {0, 0, 0, 25},
        StrokeWidth = 0
    })

    table.insert(graphics, {
        Type = "Label",
        Text = "->",
        Size = {15, max_depth/10},
        Position = {(x+(max_width/4.5))-40, y},
        HTextAlign = "Right",
        Font = Defaults.Font,
        FontSize = Defaults.FontSize,
        Fill = {0, 0, 0, 0},
        StrokeWidth = 0
    })

    layout[string.format("fade_time_%d %d", preset, page_index)] = {
        PrettyName = string.format("Area Slot %d~Preset %d~Fade Time", page_index, preset),
        Style = "Text",
        TextBoxStyle = "Normal",
        Margin = 3,
        Size = {41, 26},
        Position = {x+(max_width/2)-5-41-36-26, y+2},
    }

    layout[string.format("preset_load_%d %d", preset, page_index)] = {
        PrettyName = string.format("Area Slot %d~Preset %d~Load", page_index, preset),
        Style = "Button",
        ButtonStyle = "Trigger",
        Legend = "Load",
        Margin = 3,
        Size = {36, 26},
        Position = {x+(max_width/2)-5-36-26, y+2},
        Color = {0, 159, 60}
    }

    layout[string.format("preset_match_%d %d", preset, page_index)] = {
        PrettyName = string.format("Area Slot %d~Preset %d~Match", page_index, preset),
        Style = "Indicator",
        IndicatorStyle = "LED",
        Margin = 7,
        Size = {26, 26},
        Position = {x+(max_width/2)-5-26, y+2},
        Color = {0, 159, 60}
    }

    alt = not alt
end

local alt = true
local starting_width = (max_width + 20) + (math.ceil( props["Presets"].Value /10) *  (max_width/2))

if props["Enable Logical Channels"].Value == "Yes" then

    table.insert(graphics, {
        Type = "Svg",
        Image = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEtLSBHZW5lcmF0b3I6IEFkb2JlIElsbHVzdHJhdG9yIDE4LjEuMSwgU1ZHIEV4cG9ydCBQbHVnLUluIC4gU1ZHIFZlcnNpb246IDYuMDAgQnVpbGQgMCkgIC0tPg0KPHN2ZyB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB2aWV3Qm94PSIwIDAgMTQuNzA3IDE0LjcwNyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMTQuNzA3IDE0LjcwNzsiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KPGc+DQoJPHJlY3QgeD0iNi4yNzUiIHk9IjAiIHN0eWxlPSJmaWxsOiMwMzAxMDQ7IiB3aWR0aD0iMi4xNTgiIGhlaWdodD0iMTQuNzA3Ii8+DQo8L2c+DQoNCjwvc3ZnPg0K",
        Position = {starting_width , 0},
        Size = {20, max_depth}
    })

    for channel = 1, props["Logical Channels"].Value do

        x = starting_width + 20 + (math.floor((channel-1)/10) * (max_width/2))
        y = ((max_depth/10) * (channel-1)) - (max_depth * (math.floor((channel-1)/10)))

        table.insert(graphics, 1, {
            Type = "Label",
            Text = string.format("Ch %d", channel),
            Size = {(max_width/2), max_depth/10},
            Position = {x, y},
            HTextAlign = "Left",
            Font = Defaults.Font,
            FontSize = Defaults.FontSize,
            Fill = alt and {0, 0, 0, 0} or {0, 0, 0, 25},
            StrokeWidth = 0
        })

        layout[string.format("channel_%d %d", channel, page_index)] = {
            PrettyName = string.format("Area Slot %d~Channel %d Level", page_index, channel),
            Style = "Fader",
            Size = {124,24},
            Position = {x + 35, y+3}
        }

        alt = not alt
    end
end