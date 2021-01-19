--Used in the entity statestack to both move and change a direction of an entity only if there is no collision ahead, else it just changes the entities direction
MultiAction = Class{__includes = BaseState}

function MultiAction:init(character, direction, houseTileMap, objectTileMap, player)
	self.player = player
    self.character = character
    self.houseTileMap = houseTileMap
    self.objectTileMap = objectTileMap

	if direction == 'random' then
		local randomizer = math.random(1,4)
		if randomizer == 1 then
			self.direction = 'right'
		elseif randomizer == 2 then
			self.direction = 'left'
		elseif randomizer == 3 then
			self.direction = 'up'
		elseif randomizer == 4 then
			self.direction = 'down'
		end

	elseif direction then
		self.direction = direction
	else
		self.direction = self.character.direction
	end
end

function MultiAction:enter()
	self.character.direction = self.direction
	self.character:changeAnimation('idle-' .. self.character.direction)

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
        if self.character.type == "police" then
            print("couldn't move")
        end
        --Is here because of bug where if character is not tweened idle sate doesn't play
        Timer.tween(0.01, {
            [self.character] = {x = self.character.gridX * 16}
        }):finish(function()
            self.character.stateStack:pop()
        end)    
    end

end

function MultiAction:update(dt)

end

function MultiAction:render()

end

