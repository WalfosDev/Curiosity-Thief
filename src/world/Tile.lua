--[[
    Tile.lua is the class for tile objects, it renders a specific tile, keeps track of its position and type (floor, wall ect…). 
]]

Tile = Class{}

function Tile:init(x, y, houseTexture, def)
    self.x = x
    self.y = y
    self.id = def.id
    self.houseTexture = houseTexture

    self.type = def.type
end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.draw(gTextures[self.houseTexture], gFrames['House'][self.id],
    (self.x - 1) * TILE_SIZE + MAP_RENDER_OFFSET_X, 
    (self.y - 1) * TILE_SIZE + MAP_RENDER_OFFSET_Y)
end