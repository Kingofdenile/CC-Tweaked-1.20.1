-- Function to check if a block is an excluded ore or its variants
local function isExcludedBlock(blockName)
    local excludedBlocks = {
        "minecraft:iron_ore",
        "minecraft:deepslate_iron_ore",
        "minecraft:lapis_ore",
        "minecraft:deepslate_lapis_ore",
        "minecraft:redstone_ore",
        "minecraft:deepslate_redstone_ore",
        "minecraft:diamond_ore",
        "minecraft:deepslate_diamond_ore",
        "minecraft:gold_ore",
        "minecraft:deepslate_gold_ore"
    }
    for _, excludedBlock in ipairs(excludedBlocks) do
        if blockName == excludedBlock then
            return true
        end
    end
    return false
end

-- Function to move forward and strip mine while avoiding excluded ores and their variants
local function tunnel(distance)
    local initialPosition = {x = turtle.getX(), y = turtle.getY(), z = turtle.getZ()}
    local stepCounter = 0

    while stepCounter < distance do
        local success, blockData = turtle.inspect()
        if success and isExcludedBlock(blockData.name) then
            -- Stop tunneling if an excluded ore is encountered
            break
        else
            -- Move forward and mine the block
            turtle.dig()
            turtle.forward()
            stepCounter = stepCounter + 1
        end
    end

    -- Return to the initial position
    local dx = initialPosition.x - turtle.getX()
    local dy = initialPosition.y - turtle.getY()
    local dz = initialPosition.z - turtle.getZ()

    turtle.turnLeft()
    turtle.turnLeft()

    while dx ~= 0 do
        turtle.forward()
        dx = dx - (dx > 0 and 1 or -1)
    end

    while dz ~= 0 do
        turtle.forward()
        dz = dz - (dz > 0 and 1 or -1)
    end

    while dy ~= 0 do
        turtle.down()
        dy = dy - (dy > 0 and 1 or -1)
    end

    turtle.turnRight()
    turtle.turnRight()

    -- Return true to indicate successful completion
    return true
end

-- Prompt user for the distance to tunnel
print("Enter the distance to tunnel:")
local distance = tonumber(read())

-- Call the tunnel function with the specified distance
local success = tunnel(distance)

-- Check if the tunneling was successful
if success then
    print("Tunneling completed successfully!")
else
    print("Tunneling failed.")
end
