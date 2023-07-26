-- Custom function to check if a value exists in a table
local function tableContains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

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

    return tableContains(oreList, blockName)
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
    local chestX, chestY, chestZ
    local facing = 0 -- 0: north, 1: east, 2: south, 3: west

    for i = -5, 5 do
        for j = -5, 5 do
            local success, blockData = turtle.inspect()
            if success and blockData.name == "minecraft:chest" then
                chestX, chestY, chestZ = turtle.getPosition()
                break
            end
            turtle.turnRight()
        end
        if chestX then
            break
        end
        turtle.turnRight()
        turtle.forward()
    end

    -- Calculate the chest's position relative to the turtle
    if chestX then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaZ = chestX - curX, chestZ - curZ

        if deltaX == 0 and deltaZ == -1 then
            facing = 0 -- North
        elseif deltaX == 1 and deltaZ == 0 then
            facing = 1 -- East
        elseif deltaX == 0 and deltaZ == 1 then
            facing = 2 -- South
        elseif deltaX == -1 and deltaZ == 0 then
            facing = 3 -- West
        end
    end

    return chestX, chestY, chestZ, facing
end

-- Function to deposit items into the chest
local function depositItems(chestX, chestY, chestZ)
    if chestX and chestY and chestZ then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaY, deltaZ = chestX - curX, chestY - curY, chestZ - curZ
        turtle.forward(deltaX)
        turtle.up(deltaY)
        turtle.back(deltaX)
        for i = 2, 16 do
    end
