--[[
Used for transitions, it fades the game in and out.
]]

FadeState = Class{__includes = BaseState}

function FadeState:init(color, time, fadeType, onFadeComplete, player)
    self.player = player
    self.isFadeState = true

    if fadeType == "in" then
        self.opacity = 0
        self.newOpacity = 255
    elseif fadeType == "out" then
        self.opacity = 255
        self.newOpacity = 0
    end

    if color == "black" then
        self.r = 0
        self.g = 0
        self.b = 0
    else
        self.r = color.r
        self.g = color.g
        self.b = color.b
    end

    self.time = time

    Timer.tween(self.time, {
        [self] = {opacity = self.newOpacity}
    })
    :finish(function()
        gStateStack:pop()
        onFadeComplete()
    end)
end

function FadeState:update(dt)

end

function FadeState:render()
    if self.player then
        love.graphics.translate(math.floor(self.player.cameraScrollx), math.floor(self.player.cameraScrolly))
    end

    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH+300, VIRTUAL_HEIGHT+300)

    love.graphics.setColor(255, 255, 255, 255)
end