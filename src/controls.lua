local count = props["Area Slots"].Value

table.insert(ctrls, {
    Name = "ip_address",
    ControlType = "Text",
    UserPin = true,
    PinStyle = "Both"
})

table.insert(ctrls, {
    Name = "port",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Min = 49152,
    Max = 65535,
    DefaultValue = 50000,
    UserPin = true,
    PinStyle = "Both"
})

table.insert(ctrls, {
    Name = "device_status",
    ControlType = "Indicator",
    IndicatorType = "Status",
    UserPin = true,
    PinStyle = "Output"
})

table.insert(ctrls, {
    Name = "connect",
    ControlType = "Button",
    ButtonType = "Toggle",
    UserPin = true,
    PinStyle = "Both"
})

table.insert(ctrls, {
    Name = "area_number",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Min = 0,
    Max = 255,
    UserPin = true,
    PinStyle = "Both",
    Count = count
})

table.insert(ctrls, {
    Name = "area_status",
    ControlType = "Indicator",
    IndicatorType = "Status",
    UserPin = true,
    PinStyle = "Output",
    Count = count
})

if props["Protocol"].Value == "DyNet 1" then
    -- should be an array of 8 buttons to set bits
    for byte = 0, 7 do
        table.insert(ctrls, {
            Name = string.format("join_byte_%s", byte),
            ControlType = "Knob",
            ControlUnit = "Integer",
            Min = 0,
            Max = 1,
            DefaultValue = 1,
            UserPin = true,
            PinStyle = "Both",
            Count = count
        })
    end

    table.insert(ctrls, {
        Name = "join_hex",
        ControlType = "Text",
        UserPin = true,
        PinStyle = "Output",
        Count = count
    })
end

for preset = 1, props["Presets"].Value do

    table.insert(ctrls, {
        Name = string.format("fade_time_%d", preset),
        ControlType = "Knob",
        ControlUnit = "Integer",
        Min = 0,
        Max = 30,
        UserPin = true,
        PinStyle = "Both",
        Count = count
    })

    table.insert(ctrls, {
        Name = string.format("preset_load_%d", preset),
        ControlType = "Button",
        ButtonType = "Trigger",
        UserPin = true,
        PinStyle = "Both",
        Count = count
    })

    table.insert(ctrls, {
        Name = string.format("preset_match_%d", preset),
        ControlType = "Indicator",
        IndicatorType = "LED",
        UserPin = true,
        PinStyle = "Output",
        Count = count
    })

end

if props["Enable Logical Channels"].Value == "Yes" then

    local min, max
    if (props['Protocol'].Value == "DyNet Text") then
        min = 0
        max = 100
    elseif (props['Protocol'].Value == "DyNet 1") then
        if props["Connection Type"].Value == "TCP" then
            min = 255
            max = 0
        elseif props["Connection Type"].Value == "Serial" then
            min = 255
            max = 1
        end
    end

    for channel = 1, props["Logical Channels"].Value do

        table.insert(ctrls, {
            Name = string.format("channel_%d", channel),
            ControlType = "Knob",
            ControlUnit = (props['Protocol'].Value == "DyNet Text") and "Percent" or "Integer",
            Min = min,
            Max = max,
            UserPin = true,
            PinStyle = "Both",
            Count = count
        })

    end
end
