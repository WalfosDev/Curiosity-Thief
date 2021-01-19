--[[
The walkState checks whether the player can move in a specified direction, it makes sure the player doesn’t collide with objects by 
checking both the houseTileMap and objectTileMap for collidable positions. Then it updates the players gridY/gridX and tweens the player
 to this new tile while playing an animation. Then it puts the player back into the idleState. If the player was able to move the 
 movement was recorded in the playerGhostPath table for the police ai to use later. 
 ]]
PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, houseTileMap, objectTileMap)
    self.player = player

    local noObject = false
    local floorOnNextTile = false

    if self.player.direction == "up" then
        if houseTileMap:checkForTileType(self.player.gridY, self.player.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.player.gridY, self.player.gridX) then
            noObject = true
        end

    elseif self.player.direction == "down" then
        if houseTileMap:checkForTileType(self.player.gridY+2, self.player.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.player.gridY+2, self.player.gridX) then
            noObject = true
        end

    elseif self.player.direction == "right" then
        if houseTileMap:checkForTileType(self.player.gridY+1, self.player.gridX+1) == "floor" then
           floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.player.gridY+1, self.player.gridX+1) then
            noObject = true
        end

    elseif self.player.direction == "left" then
        if houseTileMap:checkForTileType(self.player.gridY+1, self.player.gridX-1) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.player.gridY+1, self.player.gridX-1) then
            noObject = true
        end

    end

    if floorOnNextTile and noObject then
        gSounds['footSteps']:play()
        gSounds['footSteps']:resume()
    end

    --Checks object collisions
    if self.player.direction == "up" and floorOnNextTile and noObject then
        --helps with player ghost
        self.player.currentMovementNum = self.player.currentMovementNum + 1
        self.player.playerGhostPath[self.player.currentMovementNum] = "up"

        self.player:changeAnimation('walk-up')
        self.player.gridY = self.player.gridY - 1
        --tweens player up
        Timer.tween(self.player.speed, {
            [self.player] = {y = self.player.gridY * 16}
        }):finish(function()
            self.player:changeState('idle')
        end)

    elseif self.player.direction == "down" and floorOnNextTile and noObject then
        --helps with player ghost
        self.player.currentMovementNum = self.player.currentMovementNum + 1
        self.player.playerGhostPath[self.player.currentMovementNum] = "down"

        self.player:changeAnimation('walk-down')
        self.player.gridY = self.player.gridY + 1
        --tweens player down
        Timer.tween(self.player.speed, {
            [self.player] = {y = self.player.gridY * 16}
        }):finish(function()
            self.player:changeState('idle')
        end)

    elseif self.player.direction == "right" and floorOnNextTile and noObject then
        --helps with player ghost
        self.player.currentMovementNum = self.player.currentMovementNum + 1
        self.player.playerGhostPath[self.player.currentMovementNum] = "right"

        self.player:changeAnimation('walk-right')
        self.player.gridX = self.player.gridX + 1
        --tweens player right
        Timer.tween(self.player.speed, {
            [self.player] = {x = self.player.gridX * 16}
        }):finish(function()
            self.player:changeState('idle')
        end)

    elseif self.player.direction == "left" and floorOnNextTile and noObject  then
        --helps with player ghost
        self.player.currentMovementNum = self.player.currentMovementNum + 1
        self.player.playerGhostPath[self.player.currentMovementNum] = "left"

        self.player:changeAnimation('walk-left')
        self.player.gridX = self.player.gridX - 1
        --tweens player left
        Timer.tween(self.player.speed, {
            [self.player] = {x = self.player.gridX * 16}
        }):finish(function()
            self.player:changeState('idle')
        end)
    else
        --Is here because of bug where if player is not tweened idle sate doesn't play
        Timer.tween(0.01, {
            [self.player] = {x = self.player.gridX * 16}
        }):finish(function()
            self.player:changeState('idle')
        end)    
    end

   
    --[[Collisions happen at the players feet, the player is only considered in the wall at there feet
    --However the players origin is not at there feet so they will be offset by 1+
    if self.player.direction == "up" then
        if houseTileMap:checkForTileType(self.player.gridY, self.player.gridX) == "floor" then
            self.player.gridY = self.player.gridY - 1
        end

    elseif self.player.direction == "down" then
        if houseTileMap:checkForTileType(self.player.gridY+2, self.player.gridX) == "floor" then
            self.player.gridY = self.player.gridY + 1
        end

    elseif self.player.direction == "right" then
        if houseTileMap:checkForTileType(self.player.gridY+1, self.player.gridX+1) == "floor" then
            self.player.gridX = self.player.gridX + 1
        end

    elseif self.player.direction == "left" then
        if houseTileMap:checkForTileType(self.player.gridY+1, self.player.gridX-1) == "floor" then
            self.player.gridX = self.player.gridX - 1
        end
    end


    --Checks object collisions
    if self.player.direction == "up" then
        if not objectTileMap:checkForObject(self.player.gridY, self.player.gridX)  then
            self.player.gridY = self.player.gridY - 1
        end

    elseif self.player.direction == "down" then
        if not objectTileMap:checkForObject(self.player.gridY+2, self.player.gridX) then
            self.player.gridY = self.player.gridY + 1
        end

    elseif self.player.direction == "right" then
        if not objectTileMap:checkForObject(self.player.gridY+1, self.player.gridX+1) then
            self.player.gridX = self.player.gridX + 1
        end

    elseif self.player.direction == "left" then
        if not objectTileMap:checkForObject(self.player.gridY+1, self.player.gridX-1) then
            self.player.gridX = self.player.gridX - 1
        end
    end]]


    --[[
    
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation]]
end

function PlayerWalkState:update(dt)
    --self.player.currentAnimation:update(dt)
    
end