-- Function to prompt user for label
local function setLabel()
    print("Please enter a label for the GPS host:")
    local label = read()
    if label ~= "" then
        shell.run("gps", "label", label)
        print("Label '" .. label .. "' has been set for the GPS host.")
    else
        print("Label cannot be empty. Please try again.")
        setLabel() -- Prompt again until a valid label is entered
    end
end

-- Function to prompt user for coordinates
local function enterCoordinates()
    print("Please enter the coordinates (x, y, z) separated by spaces:")
    local input = read()
    local x, y, z = input:match("(%S+)%s+(%S+)%s+(%S+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    if x and y and z then
        shell.run("gps", "host", x, y, z)
        print("GPS host coordinates set to (" .. x .. ", " .. y .. ", " .. z .. ").")
    else
        print("Invalid input format. Coordinates must be numbers separated by spaces.")
        enterCoordinates() -- Prompt again until valid coordinates are entered
    end
end

-- Main program
print("Welcome to the GPS Host Setup!")
setLabel()
enterCoordinates()
