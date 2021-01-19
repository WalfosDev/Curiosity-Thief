--Used in the entity statestack to move the entity forward however only if there is no collision ahead

MoveAction = Class{__includes = BaseState}

function MoveAction:init(character, houseTileMap, objectTileMap, player)
	self.player = player
    self.character = character
    self.houseTileMap = houseTileMap
    self.objectTileMap = objectTileMap
end

function MoveAction:enter()

    local noObject = false
    local floorOnNextTile = false

    if self.character.direction == "up" then
        if self.houseTileMap:checkForTileType(self.character.gridY, self.character.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not self.objectTileMap:checkForObjectCollisions(self.character.gridY, self.character.gridX) then
            noObject = true
        end

    elseif self.character.direction == "down" then
        if self.houseTileMap:checkForTileType(self.character.gridY+2, self.character.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not self.objectTileMap:checkForObjectCollisions(self.character.gridY+2, self.character.gridX) then
            noObject = true
        end

    elseif self.character.direction == "right" then
        if self.houseTileMap:checkForTileType(self.character.gridY+1, self.character.gridX+1) == "floor" then
           floorOnNextTile = true
        end
        if not self.objectTileMap:checkForObjectCollisions(self.character.gridY+1, self.character.gridX+1) then
            noObject = true
        end

    elseif self.character.direction == "left" then
        if self.houseTileMap:checkForTileType(self.character.gridY+1, self.character.gridX-1) == "floor" then
            floorOnNextTile = true
        end
        if not self.objectTileMap:checkForObjectCollisions(self.character.gridY+1, self.character.gridX-1) then
            noObject = true
        end

    end

    --Checks object collisions
    if self.character.direction == "up" and floorOnNextTile and noObject then
        self.character:changeAnimation('walk-up')
        self.character.gridY = self.character.gridY - 1
        --tweens character up
        Timer.tween(self.character.speed, {
            [self.character] = {y = self.character.gridY * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)

    elseif self.character.direction == "down" and floorOnNextTile and noObject then
        self.character:changeAnimation('walk-down')
        self.character.gridY = self.character.gridY + 1
        --tweens character down
        Timer.tween(self.character.speed, {
            [self.character] = {y = self.character.gridY * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)

    elseif self.character.direction == "right" and floorOnNextTile and noObject then
        self.character:changeAnimation('walk-right')
        self.character.gridX = self.character.gridX + 1
        --tweens character right
        Timer.tween(self.character.speed, {
            [self.character] = {x = self.character.gridX * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)

    elseif self.character.direction == "left" and floorOnNextTile and noObject  then
        self.character:changeAnimation('walk-left')
        self.character.gridX = self.character.gridX - 1
        --tweens character left
        Timer.tween(self.character.speed, {
            [self.character] = {x = self.character.gridX * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)
    else
        --Is here because of bug where if character is not tweened idle sate doesn't play
        Timer.tween(0.01, {
            [self.character] = {x = self.character.gridX * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)    
    end

end

function MoveAction:update(dt)

end

function MoveAction:render()

end

