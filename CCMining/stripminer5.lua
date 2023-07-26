-- Function to prompt the user for the tunnel distance
local function promptTunnelDistance()
    print("Enter the tunnel distance:")
    local tunnelDistance = tonumber(read())

    if tunnelDistance == nil or tunnelDistance <= 0 then
        print("Invalid distance. Please enter a positive number.")
        return promptTunnelDistance()
    end

    return tunnelDistance
end

-- Function to store the initial coordinates
local function storeInitialCoordinates()
    local startX, startY, startZ = gps.locate()
    if startX and startY and startZ then
        return { x = startX, y = startY, z = startZ }
    else
        print("GPS not available. Please move the turtle to its starting position.")
        return storeInitialCoordinates()
    end
end

-- Function to return to the initial coordinates
local function returnToInitialCoordinates(initialPos)
    if initialPos and initialPos.x and initialPos.y and initialPos.z then
        local curX, curY, curZ = gps.locate()
        if curX and curY and curZ then
            local deltaX, deltaY, deltaZ = initialPos.x - curX, initialPos.y - curY, initialPos.z - curZ
            turtle.turnRight()
            turtle.turnRight()
            turtle.forward(deltaZ)
            turtle.turnRight()
            turtle.turnRight()
            turtle.up(deltaY)
            turtle.back(deltaX)
            turtle.forward(deltaX)
            turtle.down(deltaY)
        end
    end
end

-- Function to check if the block is one of the specified ores
local function isOre(blockName)
    local oreList = {
        "minecraft:gold_ore",
        "minecraft:diamond_ore",
        "minecraft:redstone_ore",
        "minecraft:lapis_ore",
        "minecraft:iron_ore",
        "minecraft:deepslate_gold_ore",
        "minecraft:deepslate_diamond_ore",
        "minecraft:deepslate_redstone_ore",
        "minecraft:deepslate_lapis_ore",
        "minecraft:deepslate_iron_ore"
    }

    return table.contains(oreList, blockName)
end

-- Function to perform the mining operation while checking for specific ores
local function performMining(tunnelDistance)
    for i = 1, tunnelDistance do
        while turtle.detect() do
            local success, blockData = turtle.inspect()
            if success and isOre(blockData.name) then
                return true
            end
            turtle.dig()
            turtle.forward()
        end
    end
    return false
end

-- Function to search for chests in a 10x10 area
local function searchForChests()
    for i = -5, 5 do
        for j = -5, 5 do
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
        turtle.forward(deltaX)
        turtle.up(deltaY)
        turtle.back(deltaX)
        for i = 2, 16 do
            turtle.select(i)
            turtle.drop()
        end
        turtle.select(1)
        turtle.down(deltaY)
        turtle.back(deltaZ)
    end
end

-- Main function to perform the strip mining and deposit items
local function stripMineAndDeposit()
    -- Prompt the user for the tunnel distance
    local tunnelDistance = promptTunnelDistance()

    local initialPos = storeInitialCoordinates()

    -- Strip mine forward while checking for specific ores
    local foundOre = performMining(tunnelDistance)

    -- Return to initial coordinates if ore found or if the mining is complete
    returnToInitialCoordinates(initialPos)

    -- Search for a chest in a 10x10 area
    local chestPos = searchForChests()

    -- Deposit items into the chest
    depositItems(chestPos)

    -- Return to the initial coordinates
    returnToInitialCoordinates(initialPos)
end

-- Call the main function to start the process
stripMineAndDeposit()
