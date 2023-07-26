-- Function to request and create a label
local function createLabel()
    print("Please enter a label for the GPS host:")
    local label = read()
    if label ~= "" then
        local gpsHost = peripheral.find("gps")
        gpsHost.setLabel(label)
        print("Label '" .. label .. "' has been set for the GPS host.")
        return true
    else
        print("Label cannot be empty. Please try again.")
        return false
    end
end

-- Function to prompt user for coordinates
local function enterCoordinates()
    print("Please enter the coordinates (x, y, z) separated by spaces:")
    local input = read()
    local x, y, z = input:match("(%S+)%s+(%S+)%s+(%S+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    if x and y and z then
        local gpsHost = peripheral.find("gps")
        gpsHost.locate(x, y, z)
        print("GPS host coordinates set to (" .. x .. ", " .. y .. ", " .. z .. ").")
    else
        print("Invalid input format. Coordinates must be numbers separated by spaces.")
    end
end

-- Main program
print("Welcome to the GPS Host Setup!")
while not createLabel() do
    -- Keep prompting for label until it's valid
end
enterCoordinates()
