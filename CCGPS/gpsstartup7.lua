-- Function to set a label for the computer/turtle
local function setComputerLabel()
    print("Please enter a label for this computer/turtle:")
    local label = read()
    if label ~= "" then
        os.setComputerLabel(label)
        print("Label '" .. label .. "' has been set for this computer/turtle.")
    else
        print("Label cannot be empty. Please try again.")
        setComputerLabel() -- Prompt again until a valid label is entered
    end
end

-- Function to prompt user for coordinates
local function enterCoordinates()
    print("Please enter the coordinates (x, y, z) separated by spaces:")
    local input = read()
    local x, y, z = input:match("(%S+)%s+(%S+)%s+(%S+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    if x and y and z then
        local modem = peripheral.find("modem") or peripheral.find("ender_modem")
        if modem then
            local success, err = pcall(gps.locate, x, y, z)
            if success then
                print("GPS host coordinates set to (" .. x .. ", " .. y .. ", " .. z .. ").")
            else
                print("GPS not available or not properly set up. Manually enter the coordinates.")
            end
        else
            print("No modem or ender modem found. Please ensure a modem is connected to the GPS host.")
        end
    else
        print("Invalid input format. Coordinates must be numbers separated by spaces.")
    end
end

-- Main program
print("Welcome to the GPS Host Setup!")
setComputerLabel()
enterCoordinates()
