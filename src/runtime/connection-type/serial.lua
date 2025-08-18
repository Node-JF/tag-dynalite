-- Services
serial = SerialPorts[1]

-----------------
----- Setup -----
-----------------

function Connect()

    isDyNetText = (Properties['Protocol'].Value == "DyNet Text")

    ResetTimers()

    -- empty command queue
    commandQueue = {}

    if not Controls["connect"].Boolean then
        SetStatus(3, "Component Manually Disconnected")
        return serial:Close()
    end

    print("User.Info: Connecting Serial Port...")

    if not serial.IsOpen then
        serial:Open(9600, 8, 'N') -- 9600,N,8,1
    end
end

----------------------------
----- Queue Management -----
----------------------------

function Dequeue()

    queueTimer:Stop()

    if #commandQueue > 0 and serial.IsOpen then Send(table.remove(commandQueue, 1)) end

    queueTimer:Start(0.1)
end

------------------------------------
----- Serial & Data Management -----
------------------------------------

serial.EventHandler = function(port, evt)

    if evt == SerialPorts.Events.Connected then

        SetStatus(0, "Connected")

        if (not isDyNetText) then Begin() end

    elseif evt == SerialPorts.Events.Data then

        SetStatus(0)

        if (isDyNetText) then
            local data = serial:Read(serial.BufferLength)
            ParseData(data)
        else
            local incoming = serial:Read(serial.BufferLength)

            if (buffer == nil) then buffer = "" end

            -- append to global buffer
            buffer = buffer .. incoming

            local data = AssertValidData()
            while data do
                ParseData(data)
                data = AssertValidData()
            end
        end

        queueTimer:Start(0)

    else

        SetStatus(4, evt)

        Timer.CallAfter(Connect, 1)

    end
end

function Send(data)

    if not serial.IsOpen then return print("User.Warning: Serial Port not Connected") end

    local command = ""

    if (isDyNetText) then

        print(string.format("Sending ASCII:%s", data))

        command = data

    else

        local hex = ""

        for i, byte in ipairs(data) do
            command = command .. string.char(byte)
            hex = hex .. string.format("[%02X]", byte)
        end

        print(string.format("Sending HEX:%s", hex))

    end

    if (isDyNetText) then command = command .. '\r' end

    serial:Write(command)

end
