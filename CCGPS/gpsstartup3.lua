-- Function to prompt user for coordinates
local function enterCoordinates()
    print("Please enter the coordinates (x, y, z) separated by spaces:")
    local input = read()
    local x, y, z = input:match("(%S+)%s+(%S+)%s+(%S+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    if x and y and z then
        local modem = peripheral.find("modem") or peripheral.find("ender_modem")
        if modem then
            local gpsHost = peripheral.wrap(modem)
            gpsHost.transmit(tonumber(x), tonumber(y), tonumber(z))
            print("GPS host coordinates set to (" .. x .. ", " .. y .. ", " .. z .. ").")
        else
            print("No modem or ender modem found. Please ensure a modem is connected to the GPS host.")
        end
    else
        print("Invalid input format. Coordinates must be numbers separated by spaces.")
    end
end

-- Main program
print("Welcome to the GPS Host Setup!")
enterCoordinates()
