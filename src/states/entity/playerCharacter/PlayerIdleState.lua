--[[
The idleState allows the player to steal or break objects along with putting the player in the walkingState when movement buttons 
are pressed.  

The walkState checks whether the player can move in a specified direction, it makes sure the player doesn’t collide with objects by 
checking both the houseTileMap and objectTileMap for collidable positions. Then it updates the players gridY/gridX and tweens the player
 to this new tile while playing an animation. Then it puts the player back into the idleState. If the player was able to move the 
 movement was recorded in the playerGhostPath table for the police ai to use later. 

Both states check whether the player should render before or after objects using the function found in the entity class that 
player inherits from. 

As I said the player can also steal objects. As the player moves around the idleState will scan the tile infront the player 
on the object tileMap and check if it is stealable. If it is stealable the canStealObject variable is set to true which makes
a the UI element in the house state indicate that the player can steal the object. Then if player presses e the object is added
 to the list of stolen objects and removed from the tileMap. 

To break objects the idleState just checks if the object canBeRemoved then removes it from the tileMap and increases the players
crime Rate.
]]
PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player, houseTileMap, objectTileMap)
    gSounds['footSteps']:pause()

    self.player = player
    self.objectTileMap = objectTileMap

    self.player:changeAnimation('idle-' .. self.player.direction)
    
    self.player:checkWheatherEntityShouldRenderBeforeOrAfterObjects(objectTileMap)

end

function PlayerIdleState:update(dt)

    --moves the player character when a button is pressed
    if love.keyboard.isDown(moveUp) then 
        self.player.direction = "up"
        self.player:changeState('walking')

    elseif love.keyboard.isDown(moveDown) then 
        self.player.direction = 'down'
        self.player:changeState('walking')

    elseif love.keyboard.isDown(moveRight) then
        self.player.direction = 'right'
        self.player:changeState('walking')

    elseif love.keyboard.isDown(moveLeft) then 
        self.player.direction = "left"
        self.player:changeState('walking')
        
    end

    --Detects if there is an interactable object near
    local yTileOffset
    local xTileOffset
    if self.player.direction == 'up' then 
        yTileOffset = 0
        xTileOffset = 0
    elseif self.player.direction == 'down' then 
        yTileOffset = 2
        xTileOffset = 0
    elseif self.player.direction == 'right' then
        yTileOffset = 1
        xTileOffset = 1
    elseif self.player.direction == "left" then 
        yTileOffset = 1
        xTileOffset = -1
    end


    local object = self.objectTileMap:checkForObject(self.player.gridY+yTileOffset, self.player.gridX+xTileOffset)
    if object then

        if object.stealable then
            self.player.canStealObject = true
            --if there is a stealble pbject then the player can press e to steal it
            if love.keyboard.wasPressed('e') then
                table.insert(self.player.stolenObjects, object)
                self.objectTileMap:removeObject(self.player.gridY+yTileOffset, self.player.gridX+xTileOffset, true)
                self.player.totalStolenObjects = self.player.totalStolenObjects + 1
                gSounds['swipe']:play()
            end
        else
            self.player.canStealObject = false
        end
        
    else
        self.player.canStealObject = false
    end

    
    --player can press r to break objects ahead of them.
    if love.keyboard.wasPressed('r') then
        if object then
            if not object.canNotBeDestroyed then
                self.objectTileMap:removeObject(self.player.gridY+yTileOffset, self.player.gridX+xTileOffset)
                self.player.crimeCoefficient =  self.player.crimeCoefficient + 2
                gSounds['break']:play()
            end
        end
    end

end