local function tableContains(table, value)
    for _, v in ipairs(table) do
        if v == value then return true end
    end
    return false
end

local function promptTunnelDistance()
    print("Enter the tunnel distance:")
    local tunnelDistance = tonumber(read())
    return (tunnelDistance and tunnelDistance > 0) and tunnelDistance or promptTunnelDistance()
end

local function storeInitialCoordinates()
    local startX, startY, startZ = gps.locate()
    return startX and startY and startZ and { x = startX, y = startY, z = startZ } or (print("GPS not available. Move the turtle."), storeInitialCoordinates())
end

local function returnToInitialCoordinates(initialPos)
    if initialPos and initialPos.x and initialPos.y and initialPos.z then
        local curX, curY, curZ = gps.locate()
        if curX and curY and curZ then
            local deltaX, deltaY, deltaZ = initialPos.x - curX, initialPos.y - curY, initialPos.z - curZ
            turtle.turnRight() turtle.turnRight() turtle.forward(deltaZ) turtle.turnRight() turtle.turnRight()
            turtle.up(deltaY) turtle.back(deltaX) turtle.forward(deltaX) turtle.down(deltaY)
        end
    end
end

local function isOre(blockName)
    local oreList = { "minecraft:gold_ore", "minecraft:diamond_ore", "minecraft:redstone_ore",
                      "minecraft:lapis_ore", "minecraft:iron_ore", "minecraft:deepslate_gold_ore",
                      "minecraft:deepslate_diamond_ore", "minecraft:deepslate_redstone_ore",
                      "minecraft:deepslate_lapis_ore", "minecraft:deepslate_iron_ore" }
    return tableContains(oreList, blockName)
end

local function performMining(tunnelDistance)
    for i = 1, tunnelDistance do
        while turtle.detect() do
            local success, blockData = turtle.inspect()
            if success and isOre(blockData.name) then return true end
            turtle.dig()
            turtle.forward()
        end
    end
    return false
end

local function searchForChests()
    local chestX, chestY, chestZ
    for i = -5, 5 do
        for j = -5, 5 do
            local success, blockData = turtle.inspect()
            if success and blockData.name == "minecraft:chest" then
                chestX, chestY, chestZ = turtle.getPosition()
                break
            end
            turtle.turnRight()
        end
        if chestX then break end
        turtle.turnRight()
        turtle.forward()
    end
    if chestX then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaZ = chestX - curX, chestZ - curZ
        local facing = deltaX == 0 and deltaZ == -1 and 0 or deltaX == 1 and deltaZ == 0 and 1 or
                       deltaX == 0 and deltaZ == 1 and 2 or deltaX == -1 and deltaZ == 0 and 3
        return chestX, chestY, chestZ, facing
    end
end

local function depositItems(chestX, chestY, chestZ)
    if chestX and chestY and chestZ then
        local curX, curY, curZ = gps.locate()
        local deltaX, deltaY, deltaZ = chestX - curX, chestY - curY, chestZ - curZ
        turtle.forward(deltaX) turtle.up(deltaY) turtle.back(deltaX)
        for i = 2, 16 do turtle.select(i) turtle.drop() end
        turtle.select(1)
        turtle.down(deltaY) turtle.back(deltaZ)
    end
end

local function stripMineAndDeposit()
    local tunnelDistance = promptTunnelDistance()
    local initialPos = storeInitialCoordinates()
    local foundOre = performMining(tunnelDistance)
    returnToInitialCoordinates(initialPos)
    local chestX, chestY, chestZ, facing = searchForChests()
    if chestX then depositItems(chestX, chestY, chestZ)
    else print("No chest found in the vicinity.") end
    returnToInitialCoordinates(initialPos)
end

stripMineAndDeposit()
