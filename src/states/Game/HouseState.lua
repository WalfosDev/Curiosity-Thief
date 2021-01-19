--[[
    This is the state where the core gameplay takes place.

    When the houseState is initialised it picks a random houseType from the house_defs then it works out the houses; 
    width and height and houseTileSet(texture for walls and floors). Then it calls houseMaker which makes the houseTileMap, 
    then it chooses a random location on the walls to place the doors based on the tileMap, then it makes the SolidObject 
    tileMap with SolidObjectMaker, then it initialises the player character as well as personAi, before finally working out 
    the timer that dictates when the policeSpawn. 

	It takes all these components and updates them in the update function as well as providing the pause functionality, 
	being able to exit house if the player is on the same tile as the door and has pressed e, and making the game over when the 
	police come in contact with the player. Additionally, it uses love.graphics.translate to move the camera relative to the 
	player such that the player is always in the center of the screen, however it stops this at the edges of the map. 

	Finally, it renders the houseTileMap, then it renders each entity individually before or after the objectsTileMap 
	depending on their variables (such as renderTopBeforeObjects). Finally, it also renders the ui element on top the 
	screen that indicates: Time left, Whether the player can steal an object and Crime Rate.

	With the houseState updating all these moving parts it causes the game to work. 
	I also mentioned doors whenever the player is on the same tile as the exit door if 
	the player presses e the state is popped and it goes back to the playState. 
   
]]
HouseState = Class{__includes = BaseState}

function HouseState:init(player)
	--If the players crime rate is higher than the max the intense_music does not stop and the calm music won't play giving a sense of intensity
	if player.crimeCoefficient < player.maxCrimeCoefficient then
		gSounds['music_calm']:play()
		gSounds['music_calm']:setVolume(0.5)
		gSounds['music_calm']:setLooping(true)
	end

	--gets the houseType for this house randomly
	local houseType = HOUSE_DEFS[self:randomTableFromTable(HOUSE_DEFS)] 
	--generates the width and height of the house based on houseType
	local map_tileWidth =   math.random(houseType.WidthMin, houseType.WidthMax)  
	local map_tileHeight =  math.random(houseType.HeightMin, houseType.HeightMax) 
    --picks a random set of textures from this houseType, these textures determine how the house will look.
	local houseTileSet = houseType.houseTileSets[math.random(#houseType.houseTileSets)] 

	--Generates the tileMap for the house.
	local houseTileMap = self:generateWallsandFloors(houseTileSet, houseType, map_tileWidth, map_tileHeight)
	self.houseTileMap = houseTileMap.house
	
	--generates the escape way for the house (ie: the door)
    local roomDoors = self:generateEscape(map_tileWidth, map_tileHeight)
    self.entrance = roomDoors["enter"]
    self.exit = roomDoors["exit"]

    --Generates the object tileMap
    self.objectTileMap = self:generateObjectTileMap(self.houseTileMap, houseType, roomDoors, houseTileMap.roomOpeningPositions, map_tileWidth, map_tileHeight)

    --Initialises the player character into the game
	self.player = player
	self.player:initialiseCharacter({
		entityDefinition = PLAYER_DEFS['Roki'],
	    x = 1, y = 1,
	    type = "player",
	    gridX = self.entrance.tileX, 
	    gridY = self.entrance.tileY+1,
	    stateMachine = StateMachine {
	        ['idle'] = function() return PlayerIdleState(self.player, self.houseTileMap, self.objectTileMap) end,
	        ['walking'] = function() return PlayerWalkState(self.player, self.houseTileMap, self.objectTileMap) end,
	    },
	})
	self.player:changeState('idle')
	self.playerCanStealObject = false

	--generates the ai into the game
	self:generateAi(houseType)
	for k,ai in pairs(self.Ai) do
    	ai:changeState('idle')
    end

    --Initialises some UI elements
    --camera scroll variable
    self.cameraScrollX = 10
    self.cameraScrollY = 10
    --default for different ui elements
    self.playerStealObjectsColour = {r=255,g=255,b=255}
	self.playerCrimeRateColour = {r=255,g=255,b=255}
	self.countDownColour = {r=255,g=255,b=255}

    --Decides how much time it takes till the police spawn.
    --The time till poice spawns is a result of the percentage of crime rate, with a higher crime rate giving less time
    --TimeTillPoliceSpawns = maxTime - ((currentCrimeRate/maxCrimeRate) * maxTime)
    self.timeTillPoliceSpawns = houseType.maxTimeBeforePoliceSpawn - ((self.player.crimeCoefficient/self.player.maxCrimeCoefficient) * houseType.maxTimeBeforePoliceSpawn)
    if self.timeTillPoliceSpawns < houseType.minTimeBeforePoliceSpawn then
		self.timeTillPoliceSpawns = houseType.minTimeBeforePoliceSpawn
	end

	--Important variable that if set to true pauses the police countdown timer
	self.pauseTimer = false

	--This is all the loigic for the police spawning and timer
    self.timerForPoliceCountDown = Timer.every(0.01, function()
    	--If the pauseTimer is set to true then the time for police to spawn is paused
    	if not self.pauseTimer then
    		self.timeTillPoliceSpawns = self.timeTillPoliceSpawns - 0.01
    	end

    	--Changes the colour of the countdown text based on how much time is left
    	if self.timeTillPoliceSpawns < 7 then
    		self.countDownColour = {r=255,g=0,b=0}
    	elseif self.timeTillPoliceSpawns < 16 then
    		self.countDownColour = {r=255,g=255,b=0}
    	end

    	--Makes the time till police spawns number go to 2 decimal places. 
    	--Multiply it by 100 to make it go 2 decimal places forward, then math.floor to round off rest, then devide by 100 to make it go 2 decimal places back
    	self.timeTillPoliceSpawns = math.floor(self.timeTillPoliceSpawns*100)/100

    	--If the timer reaches 0 then police spawning logic begins
    	if self.timeTillPoliceSpawns < 0 then
    		self.timerForPoliceCountDown:remove() --removes timer
    		--activates intense music
    		gSounds['music_calm']:stop()
    		gSounds['music_intense']:play()
			gSounds['music_intense']:setVolume(1)
			gSounds['music_intense']:setLooping(true)
			gSounds['fbiOpenUp']:play()

			--incase the time till police spawn was lower than 0 then its set to 0
    		self.timeTillPoliceSpawns = 0

    		--If it is in the tutorial then no police will spawn but just a diologue, because the tutorial is giving the player a chance to learn
    		if self.player.tutorial then
    			self.player:updateTutorial('block police from spawning',self)
    		else
	    		self:spawnPolice()
	    		--if the crime rate is higher than the max then more police spawn, per crime rate gone over
	    		if self.player.maxCrimeCoefficient - self.player.crimeCoefficient < 0 then
	    			local ammountOfPolice = math.abs(self.player.maxCrimeCoefficient - self.player.crimeCoefficient)
	    			--initialises more police
	    			for i = 1, ammountOfPolice do
	    				Timer.after(i*2, function()
	    					self:spawnPolice()
	    				end)
	    			end

	    		--it brings in 1 police every 4 seconds up to a max of 3
	    		else
	    			for i = 1, 3 do
	    				Timer.after(i*4, function()
	    					self:spawnPolice()
	    				end)
	    			end
	    		end--end of if over max		
	    	end--end of if tutorial
    	end--end of if time < 0
    end) --end of timer

    --updates the tutorial
    self.player:updateTutorial('houseState initialised',self)
end


function HouseState:enter(lastStateWasFadeState)
	--if the timer was paused its always resumed on enter
	self.pauseTimer = false

	gSounds['music_calm']:resume()
	gSounds['music_intense']:resume()

	--This state may be entered twice because of the fadeState and diolgue state both popping so if the last state was the fadeSate then it will not register
	if not lastStateWasFadeState then
		self.player:updateTutorial('houseState entered',self)
	end
end


function HouseState:update(dt)
	--updates all entities
	self.player:update(dt)
	for k,ai in pairs(self.Ai) do
    	ai:update(dt)
    end

	--Allows player to leave house using the exit. 
	--If the player is on the smae tile as the exit then it allows them the opportunity to leave by pressing e
	local exitPositions = self.exit:returnTilePositions()
	--loops through the position of the exiit
	for k, exitPosition in pairs(exitPositions) do
		--if the exit position is the smae as the players position
        if exitPosition.y == self.player.gridY and exitPosition.x== self.player.gridX then
        	--e is pressed then leaves house
        	if love.keyboard.wasPressed('e') then
        		if self.player.canLeaveHouse then
	        		self.timerForPoliceCountDown:remove()
	        		gStateStack:push(FadeState("black", 0.5, "in", function()
			            gStateStack:pop()
			            gStateStack:push(FadeState("black", 0.5, "out", function() end,self.player))--end of second fade state function
			        end,self.player))--end of first fade state function
        		end
         	end

        end
    end

    --pauses game
    if love.keyboard.wasPressed('p') then
    	if self.player.canPause then
	    	self.pauseTimer = true
	        gStateStack:push(PauseState(self.player))
	    end
    end

    --The game ends if the police ai are in a 1 tile radius of the player
    if self:CheckIfPoliceIsInPlayerRadius() then
    	self.pauseTimer = true
    	self.timerForPoliceCountDown:remove()
    	gStateStack:push(LoseState(self.player))
    end

    --updates the ui that says wheather the player can steal an object or not
    if self.player.canStealObject then
		self.playerCanStealObject = "press e to steal"
		self.playerStealObjectsColour = {r=0,g=255,b=0}
	else
		self.playerCanStealObject = "nothing to steal"
		self.playerStealObjectsColour = {r=255,g=255,b=255}
	end
	--Updates the ui colour of the players crimeRate
	if self.player.crimeCoefficient > self.player.maxCrimeCoefficient then
		self.playerCrimeRateColour = {r=255,g=0,b=0}
	elseif self.player.crimeCoefficient > self.player.maxCrimeCoefficient - 10 then
		self.playerCrimeRateColour = {r=255,g=255,b=0}
	else
		self.playerCrimeRateColour = {r=255,g=255,b=255}
	end

	--Stes the cameraScrollx and cameraScrollY such that the player is in the center of the screen
    --clamp movement of the camera's X at the edgesof the screen, so the camera will not moce past the edge
    self.cameraScrollX = math.max(10,
    math.min(TILE_SIZE * self.houseTileMap.width - VIRTUAL_WIDTH + 16,
    self.player.x - VIRTUAL_WIDTH /  2)
    )

    self.cameraScrollY = math.max(-15,
    math.min(TILE_SIZE * self.houseTileMap.height - VIRTUAL_HEIGHT + 16,
    self.player.y - VIRTUAL_HEIGHT / 2)
    )

    --sends camera scroll info incase any states pushed after this require that info
    self.player.cameraScrollx = self.cameraScrollX
    self.player.cameraScrolly = self.cameraScrollY
end


function HouseState:render()
	--shifts all things rendered by this x, y making the camera move
	love.graphics.translate(-math.floor(self.cameraScrollX), -math.floor(self.cameraScrollY))

	--makes a black background
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle('fill', 0, 0, (self.houseTileMap.width+2)*16, (self.houseTileMap.height+2)*16)

	--resets colour to white so textures are their normal colour
	love.graphics.setColor(255, 255, 255, 255)

    self.houseTileMap:render()

    self.entrance:render()
    self.exit:render()

    --This bit of code allows for entities to render before or after the objects based on some variables.
    --The entities top and ottom half render seperatelty.
    --This produces a 3d effect when passing soe objects.

    if self.player.renderTopBeforeObjects then
    	self.player:renderTop()
    end
    if self.player.renderBottomBeforeObjects then
    	self.player:renderBottom()
    end

    for k,ai in pairs(self.Ai) do
	    if ai.renderTopBeforeObjects then
	    	ai:renderTop()
	    	ai:render()
	    end

	    if ai.renderBottomBeforeObjects then
	    	ai:renderBottom()
	    end
    end

    self.objectTileMap:render() --renders the objects

    for k,ai in pairs(self.Ai) do
	    if not ai.renderTopBeforeObjects then
	    	ai:renderTop()
	    	ai:render()
	    end

	    if not ai.renderBottomBeforeObjects then
	    	ai:renderBottom()
	    end
    end

    if not self.player.renderTopBeforeObjects then
    	self.player:renderTop()
    end
    if not self.player.renderBottomBeforeObjects then
    	self.player:renderBottom()
    end

    --Draws the playerUi base texture
	love.graphics.draw(gTextures['playerUi'], self.player:cam(0,"x"), self.player:cam(0,"y"))

    love.graphics.setFont(gFonts['extra-small'])

    --Player can steal objects text 
    love.graphics.setColor(self.playerStealObjectsColour.r, self.playerStealObjectsColour.g, self.playerStealObjectsColour.b)
	love.graphics.printf(tostring(self.playerCanStealObject), self.player:cam(4, "x"), self.player:cam(8,"y"), 200, 'left')
	--crime rate text
	love.graphics.setColor(self.playerCrimeRateColour.r, self.playerCrimeRateColour.g, self.playerCrimeRateColour.b)
	love.graphics.printf("Crime Rate:"..tostring(self.player.crimeCoefficient), self.player:cam(4, "x"), self.player:cam(16,"y"), 200, 'left')
	--Time left text
	love.graphics.setColor(self.countDownColour.r, self.countDownColour.g, self.countDownColour.b)
	love.graphics.printf("Time left:"..tostring(self.timeTillPoliceSpawns),  self.player:cam(4, "x"), self.player:cam(0,"y"), 150, 'left')

	--sets everything back to white to prevent colour stain
	love.graphics.setColor(255,255,255,255)
end




--------------------OTHER METHODS OF THE HOUSETSATE-----------------

--This generates the houses timeMap
function HouseState:generateWallsandFloors(houseTileSet, houseTypeInfo, map_tileWidth, map_tileHeight)
	--makes the houses base
	local house = HouseMaker(houseTileSet, houseTypeInfo, map_tileHeight, map_tileWidth)

	--procedurally generates the houses interiour
	house:ProcedurallyGenerateRooms()

	--returns tile map
	return house:ReturnHouse()
end

--This generates the houses doors
function HouseState:generateEscape(map_tileWidth, map_tileHeight)
	--gets a door position 
	local door1PositionX
	local door2PositionX
	--makes sure door isn't inside a wall
	repeat
		door1PositionX = math.random(1, 10)
		local tileType = self.houseTileMap:checkForTileType(1, door1PositionX)
	until tileType == "wall"

	repeat
		door2PositionX = math.random(map_tileWidth - 10, map_tileWidth - 1)
		local tileType = self.houseTileMap:checkForTileType(1, door2PositionX)
	until tileType == "wall"

	
	return {
	enter = Object(ESCAPE_GAME_OBJECT_DEFS['Door'], door1PositionX, 1), 
	exit = Object(ESCAPE_GAME_OBJECT_DEFS['Door'], door2PositionX, 1)
	}
end

--This generates the object tileMap
function HouseState:generateObjectTileMap(houseTileMap, houseType, escapeWayPositions, roomOopeningPositions, map_tileWidth, map_tileHeight)
	local objects = SolidObjectsMaker(houseTileMap, escapeWayPositions, roomOopeningPositions, map_tileHeight, map_tileWidth)

	objects:intelligentlyGenerateObjects(houseType)

	return objects:returnObjects()
end

--This initialises and places the PersonAi in the house
function HouseState:generateAi(houseType)
	self.Ai = {}
	---number of ai is based on house type
	local numberOfAi = math.random(houseType.minNumberOfai, houseType.maxNumberOfai)
	if numberOfAi > 0 then
		for i = 1,numberOfAi do
			local aiPositionX
			local aiPositionY
			--randomly places ai in mapand makes sure they aren't inside a wall
			repeat
				aiPositionY = math.random(1, self.houseTileMap.height)
				aiPositionX = math.random(1,self.houseTileMap.width)
				local tileTypeHouse = self.houseTileMap:checkForTileType(aiPositionY, aiPositionX)
				local tileTypeObject = self.objectTileMap:checkForObject(aiPositionY, aiPositionX)
			until tileTypeHouse == "floor" and not tileTypeObject

			--once suitibal coordinates have been chosen instantiates the ai
			local personAi = PersonAi()
			personAi:initialiseCharacter({
				entityDefinition = NPC_DEFS['Bob'],
			    x = 1, y = 1,
			    type = "person",
			    gridX = aiPositionX, 
			    gridY = aiPositionY-1,
			    enableStateStack = true,
			    stateMachine = StateMachine {
			        ['idle'] = function() return PersonAiIdleState(self.player, self.houseTileMap, self.objectTileMap, personAi) end,
			        ['fleeing'] = function() return PersonAiFleeingState(self.player, self.houseTileMap, self.objectTileMap, personAi) end,
			    },
			})
			
			table.insert(self.Ai, personAi)
		end
	end

end

--This spawns police in the house
function HouseState:spawnPolice()
	local policeAi = PoliceAi()
	policeAi:initialiseCharacter({
		entityDefinition = NPC_DEFS['Police'],
	    x = 1, y = 1,
	    type = "police",
	    gridX = self.entrance.tileX, 
    	gridY = self.entrance.tileY+1,
	    enableStateStack = true,
	    stateMachine = StateMachine {
	        ['searching'] = function() return PoliceAiSearchingState(self.player, self.houseTileMap, self.objectTileMap, policeAi) end,
	    },
	})
	
	table.insert(self.Ai, policeAi)

	policeAi:changeState('searching')
end

--Checks if police are n a 1 tile radius of the player
function HouseState:CheckIfPoliceIsInPlayerRadius()
	local policeIsInPlayerRadius = false

	--a list of tiles that are around the player
	local positionsToScanForPolice = {
		up         =    {x = self.player.gridX,   y = self.player.gridY},
		down       =    {x = self.player.gridX,   y = self.player.gridY+2},

		left       =    {x = self.player.gridX-1, y = self.player.gridY+1},
		right      =    {x = self.player.gridX+1, y = self.player.gridY+1},

		upperLeft  =    {x = self.player.gridX-1, y = self.player.gridY},
		upperRight =    {x = self.player.gridX+1, y = self.player.gridY},

		lowerLeft  =    {x = self.player.gridX-1, y = self.player.gridY+2},
		lowerRight =    {x = self.player.gridX+1, y = self.player.gridY+2},

		--upperCenter=	{x = self.player, 	y = self.player},
		lowerCenter=	{x = self.player.gridX,   y = self.player.gridY+1},
	}

	--loops through the police and above list to see if the police are at any of those positions
	for k, ai in pairs(self.Ai) do
		if ai.type == "police" then
			--loops through the list
			for k, tile in pairs(positionsToScanForPolice) do
				--checks if police are on any of those positions grid positions, gridY+1 checks for the bottom half of the police
				if ai.gridX == tile.x and ai.gridY+1 == tile.y then
					policeIsInPlayerRadius = true
				end
			end
		end
	end

	return policeIsInPlayerRadius
end

--Chooses a random table from a table of tables
function HouseState:randomTableFromTable(specifiedTable)
	local tableElected
	local tableChosen = false

	repeat 
		for key, object in pairs(specifiedTable) do
			if math.random(1,4) == 1 then
				tableElected = key
				tableChosen = true
			end
		end
	until tableChosen

	return tableElected
end
