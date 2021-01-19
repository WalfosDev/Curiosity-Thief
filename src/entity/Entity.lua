--[[
All entities in my game inherit properties from the entity class which keeps track of 
and performs basic entity functions such as: rendering, grid positions, positions, state machines, 
speed, texture, animations, current animation frame etc.… The entities in my game are mostly humans
 which have a height of 2 tiles so the class is oriented towards this. In addition, the entity class
  contains; (a)More complex rendering, (b)A stateStack and (c) Ai analysis functions, all of which I will now explain. 

(a)When I say more complex rendering the entity class makes it such that the game can render 
the top half and bottom half of the entity separately. You may ask what purpose does this serve? 
Well objects in the game can pick specific tiles on them that are collidable, this is good because 
it allows the entities to pass through parts of objects that you can normally in real life, making 
a more realistic 3d effect. Example: There is a tree object in the game, however only the bottom tiles 
of the tree are collidable because that is where the plant pot is, the player can pass behind the rest 
of the tree because it isn’t collidable giving a 3d effect. Now here is where the rendering comes into 
play, the objects also have a definition that dictates whether the player should render before or after 
the object that the player is currently on it. There is a function in the entity class 
:checkWheatherEntityShouldRenderBeforeOrAfterObjects(objectTileMap) that sorts through the object tile 
map and checks the entity location for this information. To make it even more realistic it checks the bottom
and top half of the entity separately activating specific variables such as renderBottomBeforeObjects and 
renderBottomBeforeObjects. Now the state that houses the game play(houseState) will use the variables to 
render the bottom half and top half of the entity separately either before or after objects based on these variables. 
The bottomHalf and topHalf are rendered separately because the player's head may be on an object that says to render 
after the object while the bottom half may say to render before the object. To avoid this issue, I made the bottom and 
top half of the player render separately. In all making the game look very 3d. 

(b)As I said earlier the entity class also has an optional stateStack which is used for ai, so now the AI can have 2 stateMachines. 
This allows for the AI to have more complex behaviour. How I designed it is such that the stateMachine of the ai normally takes care 
of general behaviours while the StateStack takes care of actions. 
These actions can be found in src/states/entity/enemyAi and they include: 
MoveAction - purely moves the entity forward if there are no collidable positions in front (checks both object and house tile maps) 
MultiAction - moves the entity and can change entities direction simultaneously 
ChangeDirectionAction - purely changes the entities direction 
ActionSetStart  - starts the action set 
ActionSetFinnished - Indicates the action set has been finished 
I wanted the actions to only start once the whole stack has been compiled so that then the stack slowly takes actions off. 
To do this I made it so that the action only starts on entering the state which is different from initializing the state, 
in that to enter the state is for the state above it to pop, so you only enter an already initialised state. 
To do this all of the actions have their actual action in their enter function while the init function just takes in directional info. 
Once your stack is compiled you push ActionSetStart state on top of it which then causes the stack to begin with actionSetStart 
immediately popping itself off the stack so the stateStack enters the next state on the stack. Finally, the actionSetFinished makes the
actionSetComplete variable in the ai be set to true, so that the other stateMachine knows when this action set was completed. 

This is a very useful system because the stateMachine can always keep scanning and doing more computational work and only call 
actions on to the stateStack to move the entity so that the behaviors process never has to be broken. 
 
(c)Other ai functions are related to analyzing the tileMaps and other entity grid positions in relation to them. 
The simplest of these is the function isEntityInDirectView() which scans for whether the entity the game is trying 
to find is directly in front of this entity. However, since it is in view, if an opaque object or tile that’s type 
is wall, is encountered then scan stops checking any further. However, in the game there are upper and lower walls 
and the entity head can go on the upper wall which may make the algorithm think there is a wall ahead so instead, 
the game scans the y axis of the bottom half of the entity which should always be on the floor. 
 
A function that is a step more advanced is the isEntityInView() function. This function is used to check whether an entity is in 
view of this current entity. Entities have a view which is in a pyramid formation starting from the entities foot. 
This function scans for another entity in a pyramid like formation, however it has some added features to make the view more realistic. 
These are: 
(1) Once an opaque object (object you can't see past) or a wall is detected then this entity stops scanning on that specific 
axis depending on direction. Example: This entity is looking to the right and sees a wall on (y2, x5) it will no longer scan 
for the players on y2. 
(2) If an object is detected on the edges of the pyramid scan view then the pyramid will no longer grow on that edge. 
This ensures that the entity can't see pasts corners. Example: This entity is facing right and encounters a wall on y6 
which is the bottom edge of the pyramid at this current stage, all tiles past y6 will not be scanned. 

The function acts a bit differently for when this entity is facing; (up and down) or (left and right). 
Because of the axises being switched however they essentially achieve the same purpose. 
By the way the pyramid view is such that it scans 1,3,5,7... tiles in a pyramid like formation from the foot. 
]]

Entity = Class{}

function Entity:init(def)
    self.entityDefinition = def.entityDefinition

    -- dimensions
    self.width = self.entityDefinition.width
    self.height = self.entityDefinition.height

    self.texture = self.entityDefinition.texture
    self.speed = self.entityDefinition.speed
    self.type = def.type
    
    -- position
    self.gridX = def.gridX
    self.gridY = def.gridY
    self.x = self.gridX * 16
    self.y = self.gridY * 16
    self.direction = 'left'
    self.entityOffset = -5

    --If true the entity renders before objects, causing the effect of the entity to appear to be behind an object
    self.renderTopBeforeObjects = false
    self.renderBottomBeforeObjects = false

    self.animations = self:createAnimations(def.entityDefinition.animations)

    self.currentAnimation = false
    self:changeAnimation('idle-down')

    self.stateMachine = def.stateMachine
    if def.enableStateStack then
        self.stateStack = StateStack()
        self.stateStack:push(ActionSetFinnished(self))
    end
end

--borrowed from cs50 assighment5 zelda
function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
            frameWidthOfAtlas = animationDef.frameWidthOfAtlas
        }
    end

    return animationsReturned
end

--borrowed from cs50 assighment5 zelda
function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

--Changes entities stateMachine
function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
    self.currentAnimation:update(dt)

end

--Entity render functions
function Entity:render()
    --self:renderTop()
    --self:renderBottom()

    --[[ CODE TO RENDER WHOLE ENTITY
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x), 
        math.floor(self.y-5) --10 px offset on the y cause the has some blank space of 10px
        )
    ]]
end

--renders top of entity
function Entity:renderTop()
    love.graphics.draw(gTextures[self.currentAnimation.texture], 
    gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x), 
    math.floor(self.y+self.entityOffset) --10 px offset on the y cause the has some blank space of 10px
    )
end

--renders bottom of entity
function Entity:renderBottom()
    love.graphics.draw(gTextures[self.currentAnimation.texture], 
    --by adding the frame width of atlass to the frames we get the bottom half of the entity
    gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame() + self.currentAnimation.frameWidthOfAtlas],  
    math.floor(self.x), 
    math.floor(self.y+16+self.entityOffset) --offsets by 16(which is the tops width), so it goes below the top peice
    )
end

--Checks wheather the enity shoulkd render before or after an object.
function Entity:checkWheatherEntityShouldRenderBeforeOrAfterObjects(objectTileMap)
    --finds the object the entity is currently on
    local objectOnTopHalfOfEntity = objectTileMap:checkForObject(self.gridY, self.gridX)
    local objectOnBottomHalfOfEntity = objectTileMap:checkForObject(self.gridY+1, self.gridX)
    
    if objectOnTopHalfOfEntity then
        if objectOnTopHalfOfEntity.renderPlayerUnderObject then
            self.renderTopBeforeObjects = true
        else 
            self.renderTopBeforeObjects = false
        end
    else
        self.renderTopBeforeObjects = false
    end

    if objectOnBottomHalfOfEntity then
        if objectOnBottomHalfOfEntity.renderPlayerUnderObject then
            self.renderBottomBeforeObjects = true
        else 
            self.renderBottomBeforeObjects = false
        end
    else
        self.renderBottomBeforeObjects = false
    end

end


-----------------The following are entity anaylis functions
--return the tile distance this entity is from the wall
function Entity:tileDistanceFromWall(houseTileMap, objectTileMap)
    local offsetXForStartingPoint
    local offsetYForStartingPoint

    if self.direction == 'right' then
        offsetXForStartingPoint = 1
        offsetYForStartingPoint = 0
    elseif self.direction == 'left' then
        offsetXForStartingPoint = -1
        offsetYForStartingPoint = 0
    elseif self.direction == 'down' then
        offsetXForStartingPoint = 0
        offsetYForStartingPoint = 1
    elseif self.direction == 'up' then
        offsetXForStartingPoint = 0
        offsetYForStartingPoint = -1
    end

    local startingPoint = {x = self.gridX, y = self.gridY}
    local count = 0
    while true do
        startingPoint.x = startingPoint.x + offsetXForStartingPoint
        startingPoint.y = startingPoint.y + offsetYForStartingPoint

        if houseTileMap:tileExist(startingPoint.y+1, startingPoint.x) then
            if houseTileMap:checkForTileType(startingPoint.y+1, startingPoint.x) ~= "floor" then
               break
            end

            if objectTileMap:checkForObjectCollisions(startingPoint.y+1, startingPoint.x) then
                break
            end
        end

        count = count+1
    end

    return count
end

--[[This funtion is used to cheack wheather an entity is in view of this current entity.

Enties have a view which is in a pyramid formation starting from the enitites foot. This function scans in the pyramid 
like formation, however it has some added features to make the view more realistic. These are:
(1)Once an opaque object(object you can't see past) or a wall is detected then this entity stops scanning on that specific
axis depending on direction. Example: This entity is looking to the right and see's an wall on (y2,x5) it will no longer scan
for the players on y2.
(2)If an object is detected on the edges of the pyramid scan view then the pyramid will no longer grow on that edge. This ensures 
that the entity can't see pasts corners. Example: This entity is facing right and encounters a wall on y6 which is the bottom edge 
of the pyramid at this current stage, all tiles past y6 will not be scanned.

The function essentialy acts a bit differently for when this entity is facing; (up and down) or (left and right).
Because of the behavipours I mentioned above however they essentially acheive the same purpose.

By the way the pyramid view is such that it scans:
1,3,5,7... tiles in a pyramid like formation from the foot.
  3        3             33333
 23        32             222 
123        321     1       1
 23        32     222      
  3        3     33333    

  width refers to the base of the pyramid
  height refers to the length of the pyramid
]]
function Entity:isEntityInView(entity, houseTileMap, ObjectTileMap,viewDistance)
     --Detects if there is an interactable object near
    local yTileOffset
    local xTileOffset
    if self.direction == 'up' then 
        yTileOffset = -1
        xTileOffset = 0
    elseif self.direction == 'down' then 
        yTileOffset = 1
        xTileOffset = 0
    elseif self.direction == 'right' then
        yTileOffset = 0
        xTileOffset = 1
    elseif self.direction == "left" then 
        yTileOffset = 0
        xTileOffset = -1
    end
    
    local entityDetected = false

    --Scans in pyramid formation left and right
    --The system is thus scannining horrizontally however the pyramid width grows vertically.
    if self.direction == 'right' or self.direction == "left" then 
        --This is the starting point of the pyramid view
        local xOriginPointToScan = self.gridX 
        local yOriginPointToScan = self.gridY+1 --starts from foot

        --This keeps track of the gridX we are currently scanning
        local xPointToScan = xOriginPointToScan
        --This keeps track of how many tiles we are scanning vertically which in this case grows the pyamids width
        local numOfVerticalBlocksToScanRelativeToThePlayer = 1

        --These values help enact the feature that stops the pyramids width from growing so it can't see past corners
        local stopExpandingBottom = false
        local stopExpandingTop = false

        --This is the list of y axis's not to check, ensures player can't see past walls ect...
        local tilesNotToCheckOnY = {}

        --The pyramids height(this entities view) streches out to view distance length
        --This loop checks through the whole pyramids length and carries our all features mentioned
        for currentPyramidLength = 1,viewDistance do

            --This value is the current y point we are scanning in the pyramid
            local yPointToScan = yOriginPointToScan 
            --This loop scans the pyramids width(vertically), on the pyramids current x axis (length)
            for i = 1,numOfVerticalBlocksToScanRelativeToThePlayer do
                
                --checks if the current point that is being scanned existsn prevents errors from occuring where tile doesn't exist
                if houseTileMap:tileExist(yPointToScan, xPointToScan) then
                    --[[If the tile is not a floor tile we are scanning then it can be assumed the enity can't see past this tile so it 
                    will prevent any further scans for the entity on this current y axis, which elps for more realistic behaviour so that
                    the entity can't see past walls.]]
                    if houseTileMap:checkForTileType(yPointToScan, xPointToScan) ~= "floor" then
                        tilesNotToCheckOnY[yPointToScan] = true --prevents this set of y tiles from being scanned
                        --[[if there is an obstacle detected at either edge of the view/pramid then the pyramid will stop
                        growing in width. This prevents the entity from seeing beyond corners. The edge includes also the tile before
                        the top and bottom edge. ]]
                        --if the obstacle is at the bottom edge.
                        if yPointToScan == (yOriginPointToScan + numOfVerticalBlocksToScanRelativeToThePlayer-1) then --there is a minus one because when scanning vertically we start from the orgin and not origin +1
                            stopExpandingBottom = yPointToScan
                        
                        --checks for an obstacle right before the bottom edge because we may miss a wall that is right infront the entity by 1 ensuring
                        --that it can't see past corners for sure. However this only activates after the pyramid has grown past length of 2 because
                        --at length of 1 and 2 it can cause the entity to no longer see forward if the entity is walking right underneath a wall.
                        elseif yPointToScan == (yOriginPointToScan + numOfVerticalBlocksToScanRelativeToThePlayer-2) and currentPyramidLength > 2 then
                            stopExpandingBottom = yPointToScan

                        --if the obstacle is at the top edge
                        elseif yPointToScan == yOriginPointToScan then
                            stopExpandingTop = yPointToScan
                        end
                    end
                
                    --[[if the object is not see through(opaque) we carry out the same behaviours as above.]]
                    local object = ObjectTileMap:checkForObject(yPointToScan, xPointToScan)
                    if object then --prevents error saying object could not be acces if no object is there
                        if object.opaque then
                            tilesNotToCheckOnY[yPointToScan] = true
                            --if the obstacle is at the bottom edge.
                            if yPointToScan == (yOriginPointToScan + numOfVerticalBlocksToScanRelativeToThePlayer-1)  or (yOriginPointToScan + numOfVerticalBlocksToScanRelativeToThePlayer-2) then
                                stopExpandingBottom = yPointToScan
                            --if the obstacle is at the top edge
                            elseif yPointToScan == yOriginPointToScan then
                                stopExpandingTop = yPointToScan
                            end
                        end
                    end

                end--end of if tile exists check

                --Carries out the feature that prevents the entity from seeing past corners if an object was encountered on the edge of the view.
                --It makes all the y axies from that point onward barred from being scanned. Which would make the pyramids width no longer grow.
                if stopExpandingTop then
                    for tile = stopExpandingTop, stopExpandingTop - viewDistance, -1 do
                        tilesNotToCheckOnY[tile] = true
                    end
                    stopExpandingTop = false
                elseif stopExpandingBottom then
                    for tile = stopExpandingBottom, stopExpandingBottom + viewDistance do
                        tilesNotToCheckOnY[tile] = true
                    end
                    stopExpandingBottom = false
                end

                --scans for the entity at this current point in the pyramid, however if this y axis is blocked off then it won't scan. Axis may be blocked cause wall was encountered ect.
                --If the player entity we are searching for is their then this function is completed.
                if entity.gridX == xPointToScan and entity.gridY+1 == yPointToScan and not tilesNotToCheckOnY[yPointToScan] then
                    entityDetected = true
                    goto endOfFunction
                end

                --increments the y by 1, thus going down the width of the pyramid
                yPointToScan = yPointToScan + 1 
            end

            --expands the height of the pyramid view
            xPointToScan = xPointToScan + xTileOffset
            --expands the width of the pyramid view
            yOriginPointToScan = yOriginPointToScan - 1
            numOfVerticalBlocksToScanRelativeToThePlayer = numOfVerticalBlocksToScanRelativeToThePlayer + 2
        end


    --detects player scan for up and down
    elseif self.direction == 'up' or self.direction == "down" then
        --This is the starting point of the pyramid view
        local xOriginPointToScan = self.gridX 
        local yOriginPointToScan = self.gridY+1 --starts from foot

        --This value is the current y point we are scanning in the pyramid
        local yPointToScan = yOriginPointToScan 
        
        --This keeps track of how many tiles we are scanning vertically which in this case grows the pyamids width
        local numOfHorizontalBlocksToScanRelativeToThePlayer = 1

        --These values help enact the feature that stops the pyramids width from growing so it can't see past corners
        local stopExpandingBottom = false
        local stopExpandingTop = false

        --This is the list of y axis's not to check, ensures player can't see past walls ect...
        local tilesNotToCheckOnX = {}

        --The pyramids height(this entities view) streches out to view distance length
        --This loop checks through the whole pyramids length and carries our all features mentioned
        for currentPyramidLength = 1,viewDistance do

            --This keeps track of the gridX we are currently scanning
            local xPointToScan = xOriginPointToScan

            --This loop scans the pyramids width(vertically), on the pyramids current x axis (length)
            for i = 1,numOfHorizontalBlocksToScanRelativeToThePlayer do
                
                --checks if the current point that is being scanned existsn prevents errors from occuring where tile doesn't exist
                if houseTileMap:tileExist(yPointToScan, xPointToScan) then
                    --[[If the tile is not a floor tile we are scanning then it can be assumed the enity can't see past this tile so it 
                    will prevent any further scans for the entity on this current y axis, which elps for more realistic behaviour so that
                    the entity can't see past walls.]]
                    if houseTileMap:checkForTileType(yPointToScan, xPointToScan) ~= "floor" then
                        tilesNotToCheckOnX[xPointToScan] = true --prevents this set of y tiles from being scanned
                        --[[if there is an obstacle detected at either edge of the view/pramid then the pyramid will stop
                        growing in width. This prevents the entity from seeing beyond corners. The edge includes also the tile before
                        the top and bottom edge. ]]
                        --if the obstacle is at the bottom edge.
                        if xPointToScan == (xOriginPointToScan + numOfHorizontalBlocksToScanRelativeToThePlayer-1) then --there is a minus one because when scanning vertically we start from the orgin and not origin +1
                            stopExpandingBottom = xPointToScan
                        
                        --checks for an obstacle right before the bottom edge because we may miss a wall that is right infront the entity by 1 ensuring
                        --that it can't see past corners for sure. However this only activates after the pyramid has grown past length of 2 because
                        --at length of 1 and 2 it can cause the entity to no longer see forward if the entity is walking right underneath a wall.
                        elseif xPointToScan == (xOriginPointToScan + numOfHorizontalBlocksToScanRelativeToThePlayer-2) and currentPyramidLength > 2 then
                            stopExpandingBottom = xPointToScan
                            
                        --if the obstacle is at the top edge
                        elseif xPointToScan == xOriginPointToScan then
                            stopExpandingTop = xPointToScan

                        elseif xPointToScan == xOriginPointToScan+1 then
                            stopExpandingTop = xPointToScan
                        end
                    end
                
                    --[[if the object is not see through(opaque) we carry out the same behaviours as above.]]
                    local object = ObjectTileMap:checkForObject(yPointToScan, xPointToScan)
                    if object then --prevents error saying object could not be acces if no object is there
                        if object.opaque then
                            tilesNotToCheckOnX[xPointToScan] = true
                            --if the obstacle is at the bottom edge.
                            if xPointToScan == (xOriginPointToScan + numOfHorizontalBlocksToScanRelativeToThePlayer-1)  or (xOriginPointToScan + numOfHorizontalBlocksToScanRelativeToThePlayer-2) then
                                stopExpandingBottom = xPointToScan
                            --if the obstacle is at the top edge
                            elseif xPointToScan == xOriginPointToScan then
                                stopExpandingTop = xPointToScan
                            end
                        end
                    end

                end--end of if tile exists check

                --Carries out the feature that prevents the entity from seeing past corners if an object was encountered on the edge of the view.
                --It makes all the y axies from that point onward barred from being scanned. Which would make the pyramids width no longer grow.
                if stopExpandingTop then
                    for tile = stopExpandingTop, stopExpandingTop - viewDistance, -1 do
                        tilesNotToCheckOnX[tile] = true
                    end
                    stopExpandingTop = false
                elseif stopExpandingBottom then
                    for tile = stopExpandingBottom, stopExpandingBottom + viewDistance do
                        tilesNotToCheckOnX[tile] = true
                    end
                    stopExpandingBottom = false
                end

                --scans for the entity at this current point in the pyramid, however if this y axis is blocked off then it won't scan. Axis may be blocked cause wall was encountered ect.
                --If the player entity we are searching for is their then this function is completed.
                if entity.gridX == xPointToScan and entity.gridY+1 == yPointToScan and not tilesNotToCheckOnX[xPointToScan] then
                    entityDetected = true
                    goto endOfFunction
                end

                --increments the y by 1, thus going down the width of the pyramid
                xPointToScan = xPointToScan + 1 
            end

            --expands the height of the pyramid view
            yPointToScan = yPointToScan + yTileOffset
            --expands the width of the pyramid view
            xOriginPointToScan = xOriginPointToScan - 1
            numOfHorizontalBlocksToScanRelativeToThePlayer = numOfHorizontalBlocksToScanRelativeToThePlayer + 2
        end

    end

    ::endOfFunction::
    return entityDetected
end

--[[this checks if the entity we are trying to scan is directly infront this entity]]
function Entity:isEntityInDirectView(entity, houseTileMap, ObjectTileMap,viewDistance)

    --Detects if there is an interactable object near
    local yTileOffset
    local xTileOffset
    if self.direction == 'up' then 
        yTileOffset = -1
        xTileOffset = 0
    elseif self.direction == 'down' then 
        yTileOffset = 1
        xTileOffset = 0
    elseif self.direction == 'right' then
        yTileOffset = 0
        xTileOffset = 1
    elseif self.direction == "left" then 
        yTileOffset = 0
        xTileOffset = -1
    end

    local entityDetected = false

    --[[There is an extra y added on up because normally we would  scan the lower wall
    --which is not a floor, so to circumvent this we have scan for the players feet
    --from our feet]]
    local xPointToScan = self.gridX
    local yPointToScan = self.gridY + 1
    local yEnityLocation = entity.gridY + 1
    local xEnityLocation = entity.gridX

    local countDownBeforeBreak
    --view distance
    for i = 1,viewDistance do
        
        if houseTileMap:tileExist(yPointToScan, xPointToScan) then

            if houseTileMap:checkForTileType(yPointToScan, xPointToScan) ~= "floor" then
                goto endOfFunction
            end
        
            local object = ObjectTileMap:checkForObject(yPointToScan, xPointToScan)
            if object then
                if object.opaque then
                    goto endOfFunction
                end
            end

        end

        if xEnityLocation == xPointToScan and yEnityLocation == yPointToScan then
            entityDetected = true
            goto endOfFunction
        end

        xPointToScan = xPointToScan + xTileOffset
        yPointToScan = yPointToScan + yTileOffset

    end


    ::endOfFunction::
    return entityDetected
end

--Checks if the entity will colide with if they face a specific direction
function Entity:willEntityCollide(direction, houseTileMap, objectTileMap)
    local entityWillCollide = false
    local noObject = false
    local floorOnNextTile = false

    if direction == "up" then
        if houseTileMap:checkForTileType(self.gridY, self.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.gridY, self.gridX) then
            noObject = true
        end

    elseif direction == "down" then
        if houseTileMap:checkForTileType(self.gridY+2, self.gridX) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.gridY+2, self.gridX) then
            noObject = true
        end

    elseif direction == "right" then
        if houseTileMap:checkForTileType(self.gridY+1, self.gridX+1) == "floor" then
           floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.gridY+1, self.gridX+1) then
            noObject = true
        end

    elseif direction == "left" then
        if houseTileMap:checkForTileType(self.gridY+1, self.gridX-1) == "floor" then
            floorOnNextTile = true
        end
        if not objectTileMap:checkForObjectCollisions(self.gridY+1, self.gridX-1) then
            noObject = true
        end

    end

    --Checks object collisions
    if direction == "up" and floorOnNextTile and noObject then
        entityWillCollide = true

    elseif direction == "down" and floorOnNextTile and noObject then
        entityWillCollide = true

    elseif direction == "right" and floorOnNextTile and noObject then
        entityWillCollide = true

    elseif direction == "left" and floorOnNextTile and noObject  then
        entityWillCollide = true

    else
        entityWillCollide = false
    end

    return entityWillCollide
end
