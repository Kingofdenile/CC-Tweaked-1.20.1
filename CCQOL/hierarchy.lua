function displayHierarchy(dir, level, maxPerLine)
    if not fs.exists(dir) or not fs.isDir(dir) then
        return
    end

    local function printEntry(entry)
        term.write(entry)
        term.write("  ")
    end

    local function newLine()
        print()
    end

    term.clear()
    term.setCursorPos(1, 1)
    print("Hierarchy starting from: " .. dir)

    local count = 0
    for _, entry in ipairs(fs.list(dir)) do
        if count >= maxPerLine then
            count = 0
            newLine()
        end

        local fullPath = fs.combine(dir, entry)
        if fs.isDir(fullPath) then
            printEntry("*" .. fs.getName(fullPath) .. "*")
            count = count + 1
            displayHierarchy(fullPath, level + 1, maxPerLine)
        else
            printEntry(entry)
            count = count + 1
        end
    end

    newLine()
end

-- Adjust the values as needed
local currentDir = shell.dir()
local maxPerLine = 5
displayHierarchy(currentDir, 0, maxPerLine)
