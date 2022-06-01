
if props['Connection Type'].Value == "Serial" then
    table.insert(pins, {
        Name = "Serial",
        Direction = "input",
        Domain = "serial",
    })
end