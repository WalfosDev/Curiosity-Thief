--[[
    Curiosity Thief
    Author: Merrick Marshall
   
    This a game I made for my CS50g final project submission. Using LOVE2D version 0.10.2/
    It is recomended to check out the README.md file for more info.

    Credit for art:
    LimeZu - https://limezu.itch.io/moderninteriors

    Credit for music:
    Who wrote the track - Dashawn O Proverbs
    Soundfx - https://freesound.org
]]

io.stdout:setvbuf("no")
require 'src/Dependencies'

function love.load()
    love.window.setTitle('Curiosity Thief')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    --game runs on a stateStack
    gStateStack = StateStack()
    gStateStack:push(TitleScreenState())

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end
