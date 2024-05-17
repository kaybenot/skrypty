function love.load()
    love.window.setTitle("Tetris")
    love.window.setMode(400, 500)
    currentScreen = "menu"

    blocks = {
        {{1, 1, 1, 1}},
        {{1, 1}, {1, 1}},
        {{1, 1, 0}, {0, 1, 1}},
        {{0, 1, 1}, {1, 1, 0}}
    }

    colors = {
        {0, 1, 1},
        {1, 1, 0},
        {1, 0, 0},
        {0, 1, 0}
    }

    function initGame()
        grid = {}
        for i = 1, 20 do
            grid[i] = {}
            for j = 1, 10 do
                grid[i][j] = 0
            end
        end
        score = 0
        newBlock()
        fallTime = 0
        fallSpeed = 0.5
        moveTime = 0
        moveSpeed = 0.1
        rotateTime = 0
        rotateSpeed = 0.2
    end

    function newBlock()
        currentBlock = blocks[math.random(1, #blocks)]
        currentColor = colors[math.random(1, #colors)]
        blockX, blockY = 3, 1
    end

    function drawGrid()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 0, 0, 200, 400)
        for i = 1, 20 do
            for j = 1, 10 do
                if grid[i][j] ~= 0 then
                    love.graphics.setColor(grid[i][j])
                    love.graphics.rectangle("fill", (j - 1) * 20, (i - 1) * 20, 20,
                    20)
                end
            end
        end
    end

    function drawBlock()
        love.graphics.setColor(currentColor)
        for i = 1, #currentBlock do
            for j = 1, #currentBlock[i] do
                if currentBlock[i][j] == 1 then
                    love.graphics.rectangle("fill", (blockX + j - 2) * 20, (blockY + i - 2) * 20, 20, 20)
                end
            end
        end
    end

    function checkCollision(xOffset, yOffset, block)
        block = block or currentBlock
        for i = 1, #block do
            for j = 1, #block[i] do
                if block[i][j] == 1 then
                    local newX = blockX + j - 1 + xOffset
                    local newY = blockY + i - 1 + yOffset
                    if newX < 1 or newX > 10 or newY > 20 or (newY > 0 and grid[newY][newX] ~= 0) then
                        return true
                    end
                end
            end
        end
        return false
    end

    function rotateBlock(block)
        local rotated = {}
        for i = 1, #block[1] do
            rotated[i] = {}
            for j = 1, #block do
                rotated[i][j] = block[#block - j + 1][i]
            end
        end
        return rotated
    end

    function placeBlock()
        for i = 1, #currentBlock do
            for j = 1, #currentBlock[i] do
                if currentBlock[i][j] == 1 then
                    grid[blockY + i - 1][blockX + j - 1] = currentColor
                end
            end
        end
    end

    function clearLines()
        local linesCleared = 0
        for i = 20, 1, -1 do
            local full = true
            for j = 1, 10 do
                if grid[i][j] == 0 then
                    full = false
                    break
                end
            end
            if full then
                table.remove(grid, i)
                table.insert(grid, 1, {})
                for j = 1, 10 do
                    grid[1][j] = 0
                end
                linesCleared = linesCleared + 1
            end
        end
        score = score + linesCleared * 100
    end

    menu = {
        startButton = {text = "Start", x = 150, y = 200, width = 100, height = 50},
        exitButton = {text = "Exit", x = 150, y = 300, width = 100, height = 50}
    }
end

function love.update(dt)
    if currentScreen == "game" then
        fallTime = fallTime + dt
        moveTime = moveTime + dt
        rotateTime = rotateTime + dt

        if fallTime >= fallSpeed then
            fallTime = fallTime - fallSpeed
            if not checkCollision(0, 1) then
                blockY = blockY + 1
            else
                placeBlock()
                clearLines()
                newBlock()
                if checkCollision(0, 0) then
                    currentScreen = "menu"
                end
            end
        end

        if moveTime >= moveSpeed then
            moveTime = moveTime - moveSpeed
            if love.keyboard.isDown("left") and not checkCollision(-1, 0) then
                blockX = blockX - 1
            end
            if love.keyboard.isDown("right") and not checkCollision(1, 0) then
                blockX = blockX + 1
            end
            if love.keyboard.isDown("down") and not checkCollision(0, 1) then
                blockY = blockY + 1
            end
        end

        if rotateTime >= rotateSpeed then
            rotateTime = rotateTime -
            rotateSpeed
            if love.keyboard.isDown("up") then
                local rotatedBlock = rotateBlock(currentBlock)
                if not checkCollision(0, 0, rotatedBlock) then
                    currentBlock = rotatedBlock
                end
            end
        end
    end
end

function love.draw()
    if currentScreen == "menu" then
        love.graphics.printf("Tetris", 0, 100, 400, "center")
        drawButton(menu.startButton)
        drawButton(menu.exitButton)
    elseif currentScreen == "game" then
        drawGrid()
        drawBlock()
        love.graphics.print("Score: " .. score, 10, 10)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if currentScreen == "menu" then
        if isInside(x, y, menu.startButton) then
            initGame()
            currentScreen = "game"
        elseif isInside(x, y, menu.exitButton) then
            love.event.quit()
        end
    end
end

function drawButton(button)
    love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
    love.graphics.printf(button.text, button.x, button.y + button.height / 4, button.width, "center")
end

function isInside(x, y, button)
    return x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height
end
