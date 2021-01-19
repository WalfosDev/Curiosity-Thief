--[[
The Tile_map class acts as a data structure stores Tile objects and Object objects in a grid. These tiles can be rendered 
to the screen or inquired. The inquiries that may be taken from this class include: the return of a specific
tile/object from a grid position, check for collisions on a specific coordinate, and to remove a tile from 
a specific coordinate. 
]]



Tile_map = Class{}

function Tile_map:init(tileMap, type, mapTileHeight, mapTileWidth)
    self.width = mapTileWidth
    self.height = mapTileHeight
    self.tileMap = tileMap
    self.type = type
end

function Tile_map:update(dt)

end

function Tile_map:returnTile(tileY,tileX)
    local tileInfo
    if self.type == "tiles" then
        local tile = self.tileMap[tileY][tileX]
        tileInfo = tile.Tile
    elseif self.type == "objects" then
        local tile = self.tileMap[tileY][tileX]
        tileInfo = tile.Object
    end

    return tileInfo
end

function Tile_map:checkForTileType(tileY, tileX)
    local tile = self.tileMap[tileY][tileX]
    return tile.Tile.type
end

function Tile_map:checkForObject(tileY, tileX)
    objectDetected = false

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tileMap[y][x]

            if tile then
                --Gets the position from this already added object
                local otherObjPositions = tile.Object:returnTilePositions()

                --for each position set it compares it with the current tiles position set
                for k, otherObjectPos in pairs(otherObjPositions) do
                    if otherObjectPos.y == tileY and otherObjectPos.x == tileX then
                        objectDetected = tile.Object
                    end
                end
            end

        end
    end

    return objectDetected
end

function Tile_map:checkForObjectCollisions(tileY, tileX)
    objectDetected = false

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tileMap[y][x]

            if tile then
                --Gets the position from this already added object
                local otherObjPositions = tile.Object:returnCollidablePositions()

                --for each position set it compares it with the current tiles position set
                for k, otherObjectPos in pairs(otherObjPositions) do
                    if otherObjectPos.y == tileY and otherObjectPos.x == tileX then
                        objectDetected = tile.Object
                    end
                end
            end

        end
    end

    return objectDetected
end

function Tile_map:removeObject(tileY, tileX, stealableObjectsOnly)

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tileMap[y][x]

            if tile then
                --Gets the position from this already added object
                local otherObjPositions = tile.Object:returnTilePositions()

                if stealableObjectsOnly then
                    --for each position set it compares it with the current tiles position set
                    for k, otherObjectPos in pairs(otherObjPositions) do
                        if otherObjectPos.y == tileY and otherObjectPos.x == tileX and tile.Object.stealable then
                            tile.Object = nil
                            self.tileMap[y][x] = nil
                            goto skip
                        end
                    end
                else
                    --for each position set it compares it with the current tiles position set
                    for k, otherObjectPos in pairs(otherObjPositions) do
                        if otherObjectPos.y == tileY and otherObjectPos.x == tileX then
                            tile.Object = nil
                            self.tileMap[y][x] = nil
                            goto skip
                        end
                    end
                end

            end

        end
    end

    ::skip::
end

function Tile_map:tileExist(tileY, tileX)
    local tileExists = false

    if self.tileMap[tileY] then
        if self.tileMap[tileY][tileX] then
            tileExists = true
        end
    end

    return tileExists
end

function Tile_map:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tileMap[y][x]
            if tile then
                if self.type == "tiles" then
                    tile.Tile:render()
                elseif self.type == "objects" then
                    tile.Object:render()
                end
            end

        end
    end

end
