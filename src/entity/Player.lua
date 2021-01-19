--[[
Inherits from entity and it's states can be found in src/states/entity/playerCharacter

The player is interesting in that the class is made in the playState however it only initaliezes the player character and 
entity in the houseState with the initialiseCharacter() function which is found in player. However, the player does inherit
from the entity class. 

First in the playState the player class holds information such as crimeRate, tutorial, stolenObjects etc… Then in the houseState
the character is initialized. The player only uses a stateMachine and does not use a stateStack. The player only has 2 states, the 
idleState and walkState.    

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
Player = Class{__includes = Entity}


function Player:init(tutorial)
    self.canInteractWithObject = false
    self.canStealObject = false
    self.stolenObjects = {}
    self.totalStolenObjects = 0
    self.moneyAmmount = 0
    self.cashInMoneyMultiplier = 1

    self.cameraScrollx = 0
    self.cameraScrolly = 0

    self.maxCrimeCoefficient = 20
    self.crimeCoefficient = 0

    self.numberOfHousesRobbed = 0

    --if the tutorial argument is true then it activates the tutorial manager
    if tutorial then
        self.tutorial = TutorialManager(self, tutorial)
    end

    --behaviours which can be enabled/disabled
    self.canPause = true
    self.canLeaveHouse = true
end

--initialises the players actual character
function Player:initialiseCharacter(def)
	self.playerGhostPath = {}
    self.currentMovementNum = 0
    
	Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end

--automaticcally offsets something by camera scroll, depending on if its a y or x coordinate value.
function Player:cam(value, axis) 
    local newValue

    if axis == "y" then
        newValue = math.floor(self.cameraScrolly + value)
    else
        newValue = math.floor(self.cameraScrollx + value)
    end

    return newValue
end

--updates the tutorial.
function Player:updateTutorial(action,stateInfo)
    if self.tutorial then
        self.tutorial:updateTutorial(action,stateInfo)
    end
end