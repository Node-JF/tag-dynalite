-- Services
sock = TcpSocket.New()
sock.ReadTimeout = 0
sock.ReconnectTimeout = 1
buffer = ""

-----------------
----- Setup -----
-----------------

function Connect()

    isDyNetText = (Properties['Protocol'].Value == "DyNet Text")

    ResetTimers()

    -- empty command queue
    commandQueue = {}

    if sock.IsConnected then sock:Disconnect() end

    if not Controls["connect"].Boolean then
        SetStatus(3, "Component Manually Disconnected")
        return sock:Disconnect()
    end

    local ip_addr = Controls["ip_address"].String:match('(%d?%d?%d%.%d?%d?%d%.%d?%d?%d%.%d?%d?%d)')

    Controls["ip_address"].Color = ip_addr and 'Green' or 'Red'

    if not ip_addr then return print("User.Error: IP address invalid") end

    print("User.Info: Connecting Socket...")

    Controls['port'].IsDisabled = isDyNetText

    sock:Connect(ip_addr, isDyNetText and 23 or math.floor(Controls['port'].Value))

end

----------------------------
----- Queue Management -----
----------------------------

function Dequeue()

    queueTimer:Stop()

    if #commandQueue > 0 and sock.IsConnected then Send(table.remove(commandQueue, 1)) end

    queueTimer:Start(0.1)
end

------------------------------------
----- Socket & Data Management -----
------------------------------------

sock.EventHandler = function(sock, evt, err)

    if evt == TcpSocket.Events.Connected then

        SetStatus(0, "Connected")

        if (not isDyNetText) then Begin() end

    elseif evt == TcpSocket.Events.Data then

        SetStatus(0)

        if (isDyNetText) then
            local data = sock:Read(sock.BufferLength)
            ParseData(data)
        else
            local incoming = sock:Read(sock.BufferLength)

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

        Connect()

    end
end

function Send(data)

    if not sock.IsConnected then return print("User.Warning: Socket not Connected") end

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

    sock:Write(command)

end
