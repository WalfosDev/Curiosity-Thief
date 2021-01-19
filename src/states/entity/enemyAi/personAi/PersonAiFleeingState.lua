--[[
The fleeingState; clears all actions off of the stack, changes the entities thought to an alarmed expression, and increases the 
players crime rate. After that the entity stays still for 2 seconds before choosing whether it should continue to stay still or 
do a pacing up and down movement. If it does a pacing up and down movement the ai’s speed increases and some actions are added 
onto the stateStack to make the ai pace up and down. 
]]
PersonAiFleeingState = Class{__includes = BaseState}

function PersonAiFleeingState:init(Player, houseTileMap, objectTileMap, PersonAi)
    self.PersonAi = PersonAi
    self.objectTileMap = objectTileMap
    self.houseTileMap = houseTileMap
    self.player = Player
    self.timer = 0

    self.PersonAi:changeAnimation('idle-' .. self.PersonAi.direction)

    --clears action set and pushes alarmed thought
    self.PersonAi.stateStack:push(ActionSetFinnished(self.PersonAi))
    self.PersonAi.stateStack:clear()
    self.PersonAi.actionSetComplete = false
    self.PersonAi:changeThoughtAnimation('alarmed')

    --increases players crimeRate
    self.player.crimeCoefficient = self.player.crimeCoefficient + math.random(1,3)
    
    if math.random(1,2) == 2 then
        gSounds['gasp1']:setVolume(0.5)
        gSounds['gasp1']:play()
    else
        gSounds['gasp2']:setVolume(0.5)
        gSounds['gasp2']:play()
    end
end

--makes the player panick walk left and right
function PersonAiFleeingState:actionWalk()
    self.PersonAi.actionSetComplete = false
    self.PersonAi.speed = 0.25
    self.PersonAi.stateStack:clear()
    self.PersonAi.stateStack:push(ActionSetFinnished(self.PersonAi))
    
    --if the ai's direction is up or down it makes them look to the side
    if self.PersonAi.direction == "up" or self.PersonAi.direction == "down" then
        self.PersonAi.direction = "right"
    end

    --if the  ai is left it walks right and vice versa
    if self.PersonAi.direction == "right" then
        self.PersonAi.stateStack:push(ChangeDirectionAction(self.PersonAi, "left"))
    elseif self.PersonAi.direction == "left" then
        self.PersonAi.stateStack:push(ChangeDirectionAction(self.PersonAi, 'right'))
    end

    --makes the ai walk until it reaches the wall or just makes it walk between 4,6 paces if the wall is far away
    local ammountOfPacesToWalk = math.min(self.PersonAi:tileDistanceFromWall(self.houseTileMap, self.objectTileMap), math.random(4,6))
    for i = 1,ammountOfPacesToWalk do
        self.PersonAi.stateStack:push(MoveAction(self.PersonAi, self.houseTileMap, self.objectTileMap, self.player))
    end
    
    --if the ai's direction is up or down it makes ensures they look to the side
    if self.PersonAi.direction == "up" or self.PersonAi.direction == "down" then
        self.PersonAi.stateStack:push(ChangeDirectionAction(self.PersonAi, 'right'))
    end

    --starts the action set
    self.PersonAi.stateStack:push(ActionSetStart(self.PersonAi))
end

function PersonAiFleeingState:update(dt)
    self.PersonAi:checkWheatherEntityShouldRenderBeforeOrAfterObjects(self.objectTileMap)

    --the ai stands still for 2 seconds before deciding what to do
    self.timer = self.timer + dt
    if not self.actionActivated and self.timer > 2 then
        self.actionActivated = true
        local currentDirection = self.PersonAi.direction
        --makes sure there is enough space to exhibit panacking behaviour
        self.PersonAi.direction = "right"
        local ammountOfPacesToWalkRight = math.min(self.PersonAi:tileDistanceFromWall(self.houseTileMap, self.objectTileMap), math.random(4,6))
        self.PersonAi.direction = "left"
        local ammountOfPacesToWalkLeft = math.min(self.PersonAi:tileDistanceFromWall(self.houseTileMap, self.objectTileMap), math.random(4,6))
        self.PersonAi.direction = currentDirection --puts ai back to their current direction

        --has a random chance to make this ai walk up and down panicking
        if 1 == math.random(1,2) and (ammountOfPacesToWalkRight > 1 or ammountOfPacesToWalkLeft > 1) then
            gSounds['panicked_talking']:setVolume(0.5)
            gSounds['panicked_talking']:play()
            self:actionWalk()
        end

    --if the ai is walkng up and down panicking this variable can be sent to true, so when they walk one stretch it sends them to walk again
    elseif self.PersonAi.actionSetComplete then
        self:actionWalk()
    end

end
