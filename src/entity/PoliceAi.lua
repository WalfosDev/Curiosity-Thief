--[[
This ai inherits from entity and it's states can be found in states.entity/enemyAI/policeAI

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
PoliceAi = Class{__includes = Entity}


function PoliceAi:init()
    self.actionSetComplete = false

    self.isPlayerGhosting = false
    self.currentPLayerGhostTileNum = 1
    self.playerGhostComplete = false
end

function PoliceAi:initialiseCharacter(def)
	Entity.init(self, def)
end

function PoliceAi:update(dt)
    Entity.update(self, dt)
end

function PoliceAi:render()
    Entity.render(self)
end

--checks if player is near police and returns a path
function PoliceAi:locatePlayerVerticallyIfNearPolice(player, ai, houseTileMap, ObjectTileMap)
    local pathToPlayer = false
    local Ai
    if ai == "self" then
        Ai = self
    else
        Ai = ai
    end

    local currentDirection = Ai.direction
    local xCurrentOfAi = Ai.gridX
    local yCurrentOfAi = Ai.gridY

    for loopsDirection = 1,2 do

        if loopsDirection == 1 then
            Ai.direction = "right"
        elseif loopsDirection == 2 then 
            Ai.direction = "left"
        end

        --see fig 8 for explination
        for currentHalf = 1,2 do
            local loopStart 
            local loopEnd
            local loopIncrements
            if currentHalf == 1 then
                loopStart = 0
                loopEnd = -3
                loopIncrements = -1
            else
                loopStart  = 0
                loopEnd = 3
                loopIncrements = 1
            end

            for tilesAwayFromCenter = loopStart, loopEnd, loopIncrements do
                --scan goes down to up, sdcanning right/left on its way up
                Ai.gridY = yCurrentOfAi + tilesAwayFromCenter

                if houseTileMap:tileExist(Ai.gridY+1, Ai.gridX) then
                    if houseTileMap:checkForTileType(Ai.gridY+1, Ai.gridX) ~= "floor" then
                        break
                    end
                
                    local object = ObjectTileMap:checkForObject(Ai.gridY+1, Ai.gridX)
                    if object then
                        if object.opaque then
                            break
                        end
                    end
                end

                --actuall movement
                if Ai:isEntityInDirectView(player, houseTileMap, ObjectTileMap, 10) then
                    local directionToSeePlayer = Ai.direction
                    pathToPlayer = {}
                    local count = 1

                    local stepsToMoveToGetToPlayerX = math.abs(player.gridX - Ai.gridX)
                    
                    --moves the amount of tiles away from the center required
                    for i = 1, stepsToMoveToGetToPlayerX do
                        pathToPlayer[count] = directionToSeePlayer
                        count = count + 1
                    end

                    if tilesAwayFromCenter ~= 0 then
                        
                        local direction 
                        if tilesAwayFromCenter < 0 then
                            direction = "up"
                        else --it was up
                            direction = "down"
                        end

                        --moves the amount of tiles away from the center required
                        for i = 1, math.abs(tilesAwayFromCenter) do
                            pathToPlayer[count] = direction
                            count = count + 1
                        end

                    end

                    goto endOfFunction
                end 
            end

        end--end of currentHalfLoop

    end

    ::endOfFunction::
    Ai.direction = currentDirection
    Ai.gridY = yCurrentOfAi
    Ai.gridX = xCurrentOfAi

    return pathToPlayer
end

function PoliceAi:locatePlayerHorizontallyIfNearPolice(player, ai, houseTileMap, ObjectTileMap)
    local pathToPlayer = false
    local Ai
    if ai == "self" then
        Ai = self
    else
        Ai = ai
    end

    local currentDirection = Ai.direction
    local xCurrentOfAi = Ai.gridX
    local yCurrentOfAi = Ai.gridY

    for loopsDirection = 1,2 do

        if loopsDirection == 1 then
            Ai.direction = "up"
        elseif loopsDirection == 2 then 
            Ai.direction = "down"
        end

        --see fig 8 for explination
        for currentHalf = 1,2 do
            local loopStart 
            local loopEnd
            local loopIncrements
            if currentHalf == 1 then
                loopStart = 0
                loopEnd = -3
                loopIncrements = -1
            else
                loopStart  = 0
                loopEnd = 3
                loopIncrements = 1
            end

            for tilesAwayFromCenter = loopStart, loopEnd, loopIncrements do
                --scan goes left to right, sdcanning up/down on its way to the right
                Ai.gridX = xCurrentOfAi + tilesAwayFromCenter

                if houseTileMap:tileExist(Ai.gridY+1, Ai.gridX) then
                    if houseTileMap:checkForTileType(Ai.gridY+1, Ai.gridX) ~= "floor" then
                        break
                    end
                
                    local object = ObjectTileMap:checkForObject(Ai.gridY+1, Ai.gridX)
                    if object then
                        if object.opaque then
                            break
                        end
                    end
                end

                if Ai:isEntityInDirectView(player, houseTileMap, ObjectTileMap, 10) then
                    local directionToSeePlayer = Ai.direction
                    pathToPlayer = {}
                    local count = 1

                    local stepsToMoveToGetToPlayerX = math.abs(player.gridY - Ai.gridY)
                    
                    print(stepsToMoveToGetToPlayerX)
                    --moves the amount of tiles away from the center required
                    for i = 1, stepsToMoveToGetToPlayerX do
                        pathToPlayer[count] = directionToSeePlayer
                        count = count + 1
                    end

                    if tilesAwayFromCenter ~= 0 then
                        
                        local direction 
                        if tilesAwayFromCenter < 0 then
                            direction = "left"
                        else --it was up
                            direction = "right"
                        end

                        --moves the amount of tiles away from the center required
                        for i = 1, math.abs(tilesAwayFromCenter) do
                            pathToPlayer[count] = direction
                            count = count + 1
                        end

                    end

                    goto endOfFunction
                end 
            end

        end--end of halves loop

    end

    ::endOfFunction::
    --Ai.direction = currentDirection
    Ai.gridY = yCurrentOfAi
    Ai.gridX = xCurrentOfAi

    return pathToPlayer
end

