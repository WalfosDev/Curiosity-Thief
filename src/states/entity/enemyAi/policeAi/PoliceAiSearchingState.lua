--[[
The police ai is an ai that spawns once the timeTillPoliceSpawns timer reaches 0. 
The police are AI that try to touch the player, which causes the player to lose the game. 
The police only need to be in a 1 tile radius of the player for the player to lose. 
The policeAi only has 1 state which is the PoliceAiSearchingState.  
The most complex part about the ai is how they locate the player.  
First the AI player Ghost, which means it follows the exact path the player took throughout the house.  
How it works is that the player has a table playerGhostPath, and everytime the player moves in a house the 
direction the player moved is added to the table. When the police spawn it runs through the first 40 movements
the player made, and puts it on the Ai’s stateStack. This table is run in reverse since a stateStack does the
last added movement first. Ex: Run,Run,Left,Run, if this sequence was added to the stateStack as is it would
result in the stack doing Run,Left,Run,Run. The player ghost function only runs through the first 40 movements
because if the player has too many movements it can cause the game to freeze as the computer adds all the
movements to the stack, which disrupts the update function. Once this stack is completed the game player Ghost 
again with the next 40 tiles the player took.  

However, playerGhosting isn’t enough for the police to get the player cause the player could just run-in circles so to supplement 
this system there is also a locatePlayer function which tries to find the player in a certain radius of the police. 
Once the player has been found the police immediately walk towards them.  

The detection process goes like this and is separate for the vertical(y) and horizontal(x) axis, here is how the Vertical axis scans: 
(a)The games store the police’s original positions 
(b)The police’s direction is manually changed to look right 
(c)The police are moved -3 tiles down from its current y to 3 tiles above its current y, on each movement it scans for the player, 
by using the isEntityInDirectView() function. 
(d)If the player was seen, the number of tiles away from the center on y axis is recorded, the direction to see the player is recorded,
and how far away the player is from this new position. 
(e)The policeAi goes back to its original position and since no action was used it looks as if nothing happened to the ai. 
(f)This information is then made into an action set and put on a stateStack. 
(g)If the player wasn’t seen this process is repeated on the left side. 
(h)end of function 
The steps are essentially the same horizontally except replace left and right with up and down, and reverse the axises. 
From then on, the police Ai uses this new path to get to the player. 
]]

PoliceAiSearchingState = Class{__includes = BaseState}

function PoliceAiSearchingState:init(Player, houseTileMap, objectTileMap, PoliceAi)
    self.PoliceAi = PoliceAi
    self.objectTileMap = objectTileMap
    self.houseTileMap = houseTileMap
    self.player = Player

    self.PoliceAi:changeAnimation('idle-' .. self.PoliceAi.direction)
    self.PoliceAi.actionSetComplete = true

    self.currentPlayerGhostTileNum = 1
    self:playerGhost()
end

--player ghosts as explained at the top of the file
function PoliceAiSearchingState:playerGhost()
    local ammountOfTilesToGhost = 40

    self.PoliceAi.isPlayerGhosting = true
    self.PoliceAi.playerGhostComplete = false

    self.PoliceAi.actionSetComplete = true
    self.PoliceAi.stateStack:clear()
    self.PoliceAi.stateStack:push(ActionSetFinnished(self.PoliceAi))
    
    local endValue = self.currentPlayerGhostTileNum
    local startValue = self.currentPlayerGhostTileNum + ammountOfTilesToGhost - 1
    for i = startValue, endValue, -1 do
        if self.player.playerGhostPath[i] then
            local directionToMove = self.player.playerGhostPath[i]
            self.PoliceAi.stateStack:push(MultiAction(self.PoliceAi, self.player.playerGhostPath[i], self.houseTileMap, self.objectTileMap, self.player))
        end
    end

    self.PoliceAi.stateStack:push(ActionSetStart(self.PoliceAi))

    self.currentPlayerGhostTileNum = self.currentPlayerGhostTileNum + ammountOfTilesToGhost
end

function PoliceAiSearchingState:locatePlayer(direction)
    self.PoliceAi.isPlayerGhosting = false
    local pathToFollow

    if direction == "vertical" then
        pathToFollow = self.PoliceAi:locatePlayerVerticallyIfNearPolice(self.player, "self", self.houseTileMap, self.objectTileMap)
    elseif direction == "horizontal" then
        pathToFollow = self.PoliceAi:locatePlayerHorizontallyIfNearPolice(self.player, "self", self.houseTileMap, self.objectTileMap)
    end

    --if the player is found then gets the path from the funciton and adds it to the action set
    if pathToFollow then
        self.PoliceAi.actionSetComplete = false
        self.PoliceAi.stateStack:clear()
        self.PoliceAi.stateStack:push(ActionSetFinnished(self.PoliceAi))
        for k, directionToMove in pairs(pathToFollow) do
            self.PoliceAi.stateStack:push(MultiAction(self.PoliceAi, directionToMove, self.houseTileMap, self.objectTileMap, self.player))
        end
        self.PoliceAi.stateStack:push(ActionSetStart(self.PoliceAi))
    end

end

function PoliceAiSearchingState:update(dt)
    --checls vertically and if that returns nothing then checks horizontally for the player
    if self.PoliceAi.actionSetComplete then
        if self.PoliceAi:locatePlayerVerticallyIfNearPolice(self.player, "self", self.houseTileMap, self.objectTileMap) then
            self:locatePlayer("vertical")
        elseif self.PoliceAi:locatePlayerHorizontallyIfNearPolice(self.player, "self", self.houseTileMap, self.objectTileMap) then
            self:locatePlayer("horizontal")
        end
    end

    --if the ai is playerghosting and the it has done ghosted the first 40 tiles it player ghosts again
    if self.PoliceAi.isPlayerGhosting then
        if self.PoliceAi.playerGhostComplete then
            self:playerGhost()
        end
    end

end
