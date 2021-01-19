--[[
The PersonAidleState just picks a random action to do: standStill or randomlyWalk, based on this it chooses an appropriate 
thought animation and calls the correct actions onto the AI’s stateStack. Whenever the action set is indicated as complete 
by the actionSetComplete variable then this process is repeated. Alongside this the states update function always calls the 
isEnityInView(player) function on the ai it’s managing, if it returns true for seeing the player then the stateMachine switches 
to the PersonAiFleeingState. 
]]
PersonAiIdleState = Class{__includes = BaseState}

function PersonAiIdleState:init(Player, houseTileMap, objectTileMap, PersonAi)
    self.PersonAi = PersonAi
    self.objectTileMap = objectTileMap
    self.houseTileMap = houseTileMap
    self.player = Player

    self.PersonAi:changeAnimation('idle-' .. self.PersonAi.direction)

    --chooses a random action
    self:actionSetComplete()
end

--chooses a random action for the ai to do
function PersonAiIdleState:actionSetComplete()
    local randomAction = math.random(1,6)
    if randomAction == 1 then
        self:actionStandStill()
    else
        self:actionRandomlyWalk()
    end
end

--makes AI walk in a random direction
function PersonAiIdleState:actionRandomlyWalk()
    self.PersonAi.actionSetComplete = false
    self.PersonAi.stateStack:clear()
    self.PersonAi.stateStack:push(ActionSetFinnished(self.PersonAi))

    self.PersonAi.stateStack:push(MoveAction(self.PersonAi, self.houseTileMap, self.objectTileMap, self.player))
    self.PersonAi.stateStack:push(MoveAction(self.PersonAi, self.houseTileMap, self.objectTileMap, self.player))
    self.PersonAi.stateStack:push(ChangeDirectionAction(self.PersonAi, 'random'))
    self.PersonAi.stateStack:push(MoveAction(self.PersonAi, self.houseTileMap, self.objectTileMap, self.player))

    self.PersonAi.stateStack:push(ActionSetStart(self.PersonAi))

    --picks a random thought to accompany this action
    local randomThought = math.random(1,6)
    if randomThought == 1 then
        self.PersonAi:changeThoughtAnimation('sing')
    elseif randomThought == 2 then
        self.PersonAi:changeThoughtAnimation('think')
    else
        self.PersonAi:changeThoughtAnimation('nothing')
    end

end

--makes this characetr stand still.
--When they stand stil they have different thoughts and each thought gives the ai a different time to stand still for.
function PersonAiIdleState:actionStandStill()
    self.PersonAi.actionSetComplete = false
    self.PersonAi.stateStack:clear()
    
    local waitTime
    local randomThought = math.random(1,3)
    if randomThought == 1 then
        self.PersonAi:changeThoughtAnimation('think')
        waitTime = math.random(1,3)
    elseif randomThought == 2 then
        self.PersonAi:changeThoughtAnimation('calling')
        waitTime = math.random(3,6)
    elseif randomThought == 3 then
        self.PersonAi:changeThoughtAnimation('phone')
        waitTime = math.random(1)
    end
    
    --makes character wait
    Timer.after(waitTime, function()
        self.PersonAi.actionSetComplete = true
        self.PersonAi:changeThoughtAnimation('nothing')
    end)
    
end

function PersonAiIdleState:update(dt)
    self.PersonAi:checkWheatherEntityShouldRenderBeforeOrAfterObjects(self.objectTileMap)

    --if the players action set is complete then a new set of actions is chosen
    if self.PersonAi.actionSetComplete then
        self.PersonAi:changeThoughtAnimation('nothing')
        self:actionSetComplete()        
    end

    --if the player is in view then the entity flees and panicks
    if self.PersonAi:isEntityInView(self.player, self.houseTileMap, self.objectTileMap, 4) then
        self.PersonAi:changeState('fleeing')
    end

end
