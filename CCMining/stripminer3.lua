-- Function to store the initial coordinates
local function storeInitialCoordinates()
    local startX, startY, startZ = gps.locate()
    return { x = startX, y = startY, z = startZ }
end

-- Function to return to the initial coordinates
local function returnToInitialCoordinates(initialPos)
    if initialPos then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaY, deltaZ = initialPos.x - curX, initialPos.y - curY, initialPos.z - curZ
        turtle.forward(deltaX)
        turtle.up(deltaY)
        turtle.back(deltaX)
        turtle.down(deltaY)
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward(deltaZ)
        turtle.turnRight()
        turtle.turnRight()
    end
end

-- Function to perform the mining operation while checking for specific ores
local function performMining(distance)
    for i = 1, distance do
        while turtle.detect() do
            local success, blockData = turtle.inspect()
            if success then
                local blockName = blockData.name
                if blockName == "minecraft:gold_ore"
                        or blockName == "minecraft:diamond_ore"
                        or blockName == "minecraft:redstone_ore"
                        or blockName == "minecraft:lapis_ore"
                        or blockName == "minecraft:iron_ore"
                        or blockName == "minecraft:deepslate_gold_ore"
                        or blockName == "minecraft:deepslate_diamond_ore"
                        or blockName == "minecraft:deepslate_redstone_ore"
                        or blockName == "minecraft:deepslate_lapis_ore"
                        or blockName == "minecraft:deepslate_iron_ore" then
                    return true
                end
            end
            turtle.dig()
            turtle.forward()
        end
    end
    return false
end

-- Function to search for chests in a 5x5 area
local function searchForChests()
    for i = -2, 2 do
        for j = -2, 2 do
            local block = turtle.inspect()
            if block and block.name == "minecraft:chest" then
                local chestX, chestY, chestZ = gps.locate()
                return { x = chestX, y = chestY, z = chestZ }
            end
            turtle.turnRight()
        end
        turtle.turnRight()
        turtle.forward()
    end
end

-- Function to deposit items into the chest
local function depositItems(chestPos)
    if chestPos then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaY, deltaZ = chestPos.x - curX, chestPos.y - curY, chestPos.z - curZ
        turtle.forward(deltaZ)
        turtle.turnRight()
        turtle.turnRight()
        turtle.up(deltaY)
        turtle.forward(deltaX)
        for i = 2, 16 do
            turtle.select(i)
            turtle.drop()
        end
        turtle.select(1)
        turtle.back(deltaX)
        turtle.down(deltaY)
        turtle.turnRight()
        turtle.turnRight()
        turtle.back(deltaZ)
    end
end

-- Main function to perform the strip mining and deposit items
local function stripMineAndDeposit()
    -- Prompt the user for the distance to strip mine
    print("Enter the distance to strip mine:")
    local distanceToMine = tonumber(read())

    if distanceToMine == nil then
        print("Invalid distance. Please enter a number.")
        return
    end

    local initialPos = storeInitialCoordinates()

    -- Strip mine forward while checking for specific ores
    local foundOre = performMining(distanceToMine)

    -- Return to initial coordinates if ore found or if the mining is complete
    returnToInitialCoordinates(initialPos)

    -- Search for a chest in a 5x5 area
    local chestPos = searchForChests()

    -- Deposit items into the chest
    depositItems(chestPos)

    -- Return to the initial coordinates
    returnToInitialCoordinates(initialPos)
end

-- Call the main function to start the process
stripMineAndDeposit()
