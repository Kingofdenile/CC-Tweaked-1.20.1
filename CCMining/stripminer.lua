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
    for _ = 1, stepCounter do
        turtle.back()
    end

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
