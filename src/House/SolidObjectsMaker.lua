SolidObjectsMaker = Class{}
--[[
*General Information*---------------------------------------------------------------------
The objectMaker is gigantic and filled with many methods desighned for generating solid objects in the room.
Since this script so big I had to devide this script into sections.
Use these keywords to jump to the section: (By highlighting the word and jumping through all instances of it)
newSection                  - Brings you to all sections
highlyImportantMethods      - This section is dedicated to the key methods required for allowing objectGenerations to work
objectGenerationMethods     - Section dedicated to intelligently placing objects and sorting them
objectCreationMethods       - Section dedicated too actually creating the objects
objectRandomizationsMethods - Section dedicated too choosing a random object
objectAnalysisFunctions     - These analyze an object in relation to the house and return what they have anylized
houseAnalysisFunctions      - These analyze the house and return specific area's/tiles that were reqested

*Overview Of SolidObjectMaker*---------------------------------------------------------------------
This script generates all objects.

*How to use the SolidObjectMaker*---------------------------------------------------------------------
To fill a house with objects from outside the script you would only need to call 3 methods.
SolidObjectMaker:init() --Initialises the object maker, making tables ect.
SolidObjectsMaker:intelligentlyGenerateObjectss() --Generates the objects into the house
SolidObjectsMaker:returnObjects() --Returns all the objects and the table of these objects which would have been developed through the generation.

However once you have called the returnObjects method the table of objects is then fed into the Tile_map class. 
With the returned table no longer being apart of the solidObjectMaker class.
Therefore to render the objects you do:
variable = SolidObjectsMaker:returnObjects()
variable:render() --which is the equivilent to tile_map render
Remember this new variable can only acces Tile_map functions and is now cut off from SolidObjectMaker Class.

Here is an example of the SolidObjectMaker in use:
function HouseState:generateSolidObjects(houseTileMap,escapeWays,roomOopeningPositions)
	local objects = SolidObjectsMaker(houseTileMap,escapeWays,roomOopeningPositions)
	--objects:GenerateObjectss()
	objects:intelligentlyGenerateObjectss()
	return objects:returnObjects()
end

*How intelligentGeneration works*---------------------------------------------------------------------
First I would like to prefix that intelligence is defined as the ability to acquire and apply knowledge and skills.
This mechanism anlayzes the already made houseTileMap (acquiring Knoledge) and places the objects accordingly (apply knoledge).

The intelligentGeneration works in tandem with game_object_defs and house_object_defs.
-game_object_defs is the script filled with the game object definitions. 
These defintions give the script: Where object should spawn, anything that happens after spawning, and other spawning info..
-house_object_defs is the script that tells us what the house should be like.
These definitions give the script: How many of each object type should spawn, what object should spawn in this house type.

This script takes this information and then places the objects accordingly.
The step by step procces is:
(1)intelligentlyGenerateObjectss() method takes the houseType and gets the houseDefinitions.
Using these definitions it determines; how many of each object should spawn for each type, and the list of objects it can choose from for each type.

(2)It feeds this inforamation into generateObjectss() on a type by type basis.

(3)In generateObjectss() a random object is chosen from the list of the object type. Based on the area spawning information from this objects definitions 
it is then put to spawn using the randomlyPlaceObject() method. However if it fails to spawn then a different object is chosen from the list and this process 
will repeat a maximum of 3 times. Once the first object is spawned it goes onto spawn the next object based on the amount of this type of object that should
spawn.

(4)In the randomlyPlaceObject() method it takes the area type and from the object given chooses a random tile from the area type.
Once position is chosen it will adjust this position based on object type and perform various checks.
Then the objects is put through into the spawnObject() method wich takes in the object and performs many checks to see if
it can spawn (example; object isn't in wall, object isn't in another object ect...). If the object can spawn it is spawned.
It returns a true value to the randomlyPlaceObjectMethod and from there the method goes into the objects_defs and see's if
there was any behaviour to be done when the object is spawned. However if the object faied these checks it is given another try to find a different tile to spawn on repeating this process.

(5) Else if the object spawned the method has done its work and the generateObjectss method goes to the next object since it got a true value on object spawned. 



]]

-----------------newSection - highlyImportantMethods----------
--[[Initialises key factors needed for the SolidObjectMaker to work]]
function SolidObjectsMaker:init(houseTileMap, escapeWays, roomOpeningPositions, mapTileHeight, mapTileWidth)
	--These aid in determining how big the table of tiles will be
	self.mapWidth = mapTileWidth
    self.mapHeight = mapTileHeight

    --Tile_map of the tiles from the houseGeneration code
    self.houseTileMap = houseTileMap
    --The positions of the door or other ecape way (should be provided in a table format)
    self.escapeWays = escapeWays


    --positions of all the room openings (should be in at table format)
    self.roomOpeningPositions = roomOpeningPositions

    --Initialises the table that will store all the objects
    self:makeObjectsTable()
end

--[[This is the table by which all the objects will be placed into]]
function SolidObjectsMaker:makeObjectsTable()
	self.objects = {}
    for y = 1, self.mapHeight do
    	table.insert(self.objects, {})
    end
end

--[[Returns the table containg all the tiles which would have been developed from the other generation functions]]
function SolidObjectsMaker:returnObjects()
	  return Tile_map(self.objects, "objects", self.mapHeight, self.mapWidth)
end

--[[Intelligently genrates and filles the house with objects by calling methods in a specific order]]
function SolidObjectsMaker:intelligentlyGenerateObjects(houseType)
	--This takes in a house_defs which describes how this house should look
	local houseType = houseType

	--From the house_object_defs it tells the algorithm how many of each object should spawn
	bedsAmmount = math.random(houseType.bedsAmmount.min, houseType.bedsAmmount.max)
	wallMountedAmmount = math.random(houseType.wallMountedAmmount.min, houseType.wallMountedAmmount.max)
	windowsAmmount = math.random(houseType.windowsAmmount.min, houseType.windowsAmmount.max)
	tablesAmmount = math.random(houseType.tablesAmmount.min, houseType.tablesAmmount.max)
	decorativeAmmount = math.random(houseType.decorativeAmmount.min, houseType.decorativeAmmount.max)
	hobbyObjectsAmmount = math.random(houseType.hobbyObjectsAmmount.min, houseType.hobbyObjectsAmmount.max)

	--It uses the generate object method to generate each object type, type by type
	self:generateObjects(windowsAmmount, houseType.windowObjects)
	self:generateObjects(tablesAmmount, houseType.tableObjects)
	self:generateObjects(bedsAmmount, houseType.bedObjects)
	self:generateObjects(wallMountedAmmount, houseType.wallMountedObjects)
	self:generateObjects(decorativeAmmount, houseType.decorativeObjects)
	self:generateObjects(hobbyObjectsAmmount, houseType.hobbyObjects)
	
end

-----------------newSection - objectGenerationMethods----------

--[[Based on information given this functions will correctly place and generatea objects.
However it randomly generates objects from a specified table of objects. With the second argument taking in this specified table of objects.
]]
function SolidObjectsMaker:generateObjects(ammountToGenerate, objectTable)
	--Uses the returnSpecifiedHouseTileMapMethod to get various positons tiles from house tiles for objects to spawn on
	local positionsUnderWalls = self:returnSpecifiedHouseTilePositions('Underneath Wall Tiles')    --This returns all tile positons of the houseTileMap which were beneath walls
	local positionsOnFloor = self:returnSpecifiedHouseTilePositions('Floor Tiles') 				   --This returns all floor tile positons of the houseTileMap excluding the ones beneath walls
	local positionsMiddleOfFloor = self:returnSpecifiedHouseTilePositions('Middle of Floor Tiles') --This returns tile positions of floor tiles which were at least 1 tile a way from all borders/walls
	local positionsInCorners = self:returnSpecifiedHouseTilePositions('Corner Floor Tiles')		   --This returns tile positions of floor tiles which were in the corners, meeting point between 2 walls
	local positionsBottomOfFloor = self:returnSpecifiedHouseTilePositions('Bottom Floor Tiles')	   --This returns tile positions of floor tiles which were directly above the bottom border of the house
	local positionsOnUpperBaseWall = self:returnSpecifiedHouseTilePositions('Upper Base Wall')				   --This returns tile positions of the upper base wall of the house, the wall that makes the houses base

	--If the ammount to generate is 0 then skip generation
	if ammountToGenerate > 0 then
		--Spawns the objects the ammount of times listed
		for i = 1, ammountToGenerate do
			--If the object does not spawn the first time, it tries again with a new object, this happens a max of 3 times to prevent crashes if no object can spawn
			for chancesToChooseNewObj = 1,4 do
				--From the table of objects given it chooses a random object. The variable objectInfo holds that object definitions information.
				local objectInfo = self:randomSpecifiedObject(objectTable)
				local objectSpawned = false --Keeps track of wheather the object spawned
				
				--Based on the object spawn location information, it takes the variable containing the table of tiles that this object can spawn on and, spawns the object.
				--The function returns a true or false value indicating wheather the object spawned succesfully.
				if objectInfo.type == "Window" then
					objectSpawned = self:randomlyPlaceObject(objectInfo, positionsOnUpperBaseWall, "Window")
				elseif objectInfo.spawnLocationInfo == "Spawn Underneath Wall" then
					objectSpawned = self:randomlyPlaceObject(objectInfo, positionsUnderWalls, "Wall Object")
				elseif objectInfo.spawnLocationInfo == "Corner Floor Tiles" then
					objectSpawned = self:randomlyPlaceObject(objectInfo, positionsInCorners, "Corner Floor Tiles")
				elseif objectInfo.spawnLocationInfo == "Middle of Floor Tiles" then
					objectSpawned = self:randomlyPlaceObject(objectInfo, positionsMiddleOfFloor, "Middle of Floor Tiles")
				elseif objectInfo.spawnLocationInfo == 'Bottom Floor Tiles' then
					objectSpawned = self:randomlyPlaceObject(objectInfo, positionsBottomOfFloor, 'Bottom Floor Tiles')
				else
					--chance to spawn object on wall or floor
					if math.random(1,3) == 3 then --Objects spawns near wall     
						objectSpawned = self:randomlyPlaceObject(objectInfo, positionsUnderWalls, "Wall Object")
					else --Object spawns near floor
						objectSpawned = self:randomlyPlaceObject(objectInfo, positionsOnFloor)
					end
				end

				--If the object spawned succesfully then go to the next objects generation
				if objectSpawned then
					goto nextObj
				end
			end --end of Chances to generate new obj 
		
		::nextObj::
		end--end of amount of objects to generate 
	end --End of ammount to genrate
end

--[[This randomly places an object on the tile positions given.
It also adjusts the objects spawn based on the AreaType of the object.

It will give the object a specified number of attempts to spawn on these tiles.
If failed the object won't spawn.
Wheather the object could spawn or not is returned.
]]
function SolidObjectsMaker:randomlyPlaceObject(objectInfo, tilesToPlaceObjectOn, objectAreaType)
	local objectSpawned = false --Keeps track of wheather or not the object spawned

	--Gives the game multiple tries to place this object on the specied tiles given 
	for i = 1,10 do
		--Based on the list of tile positions given it loops through all positions.
		--With each position having a random chance for the specified object to spawn on it.
		for k, placableTile in ipairs(tilesToPlaceObjectOn) do
	    	if math.random(1,3) == 3 then --Chance for object to spawn on any given set of positions

	    		local objectY
	    		--For particular objectAreaTypes(area where this object will spawn) the y position should be altered.
	    		--For example if an object is going to spawn against a wall, for it to spawn against a wall the algorithm change the y position such that the object looks like it's against the wall
	    		if objectAreaType == "Wall Object" or objectAreaType == "Corner Floor Tiles" or objectAreaType ==  'Bottom Floor Tiles' then
	    			--The object info may specify that it doesn't want the object to be placed higher.
		    		if objectInfo.doNotrenderHigherOnWall then
		    			objectY = placableTile.y 
		    		elseif objectInfo.placeMuchHeigherOnWalls then
		    			objectY = placableTile.y - objectInfo.tileHeight
		    		else
		    			--Makes the objects y position be higher, by putting the y position the objects own length up
		    			objectY = (placableTile.y - objectInfo.tileHeight) + 1
		    		end
	    		else --If its not the particular type the objects y position stays as is
	    			objectY = placableTile.y
	    		end

	    		--This actually spawns the object at the x position and y position of the current tile the algoritm is on in the list of tiles 
	    		--Returns a value indicating wheather the object was able to spawn
	    		if objectAreaType == "Middle of Floor Tiles" then --If the object type is middle of room it needs to go through a specified check 
					if self:checkIfMiddleOfFloorTilesCanSpawn(objectInfo,placableTile,objectY,objectAreaType) then  --Spawns the object if all conditions are met (its in the middle of the room.)
						objectSpawned = self:spawnObject(objectInfo, placableTile.x, objectY, false, objectAreaType)
					end
	    		else --Spawns everything else normally
	    			objectSpawned = self:spawnObject(objectInfo, placableTile.x, objectY, false, objectAreaType)
	    		end

	    		--If the object was able to spawn it will handle post spawn information
	    		if objectSpawned then
	    			local object = Object(objectInfo, placableTile.x, objectY) --requires the object
	    			--objectsCanBePlaced is a definition that indicates wheather more objects should be placed on this object
	    			if objectInfo.objectCanBePlacedOnThisObject then
	    				self:spawnItemsToBePlaced(object, objectInfo)
	    			end
				   	--The onSpawn information is things that should happen when the object spawns
					if objectInfo.onSpawnInformation then
						--For an object with its on spawn information type being "multiple object spawn" it will have a function assoiated with it
						--that list the objects that should spawn and its up to the spawnMultipleObjects function to spawn these objects.
						if objectInfo.onSpawnInformation.type == "multiple objects spawn" then
							self:spawnMultipleObject(objectInfo.onSpawnInformation.OnSpawn(object))
						end
					end
					--Once the object spawned it leaves the loops
	    			goto continue
	    		end

	    	end

	   	end
	end

   	::continue::
   	--returns if the objectSpawned
   	return objectSpawned
end
--This function was made to make the randomlyPlaceObjects() more readable
function SolidObjectsMaker:checkIfMiddleOfFloorTilesCanSpawn(objectInfo, placableTile, objectY, objectAreaType)
	--The following chunck of code is used to help generate objects of the middle floor tiles type
	--An object with the spawning area specification should be spawned at least 1 tile away from all walls/borders
	--This code ensures this
	--Spawns tiles only in the middle of the room, it checks by moving this object around to make sure its not near a wall

	--Nudges the tile up, down, left, right and makes sure its not close to any walls, and returns a can spawn or can not spawn value.
	--It would not be able to spawn if it goes inside of a wall.
	--Therefore if we nudge the object in all directions and it can spawn in all direction it is not near a wall.
	local objectsToCheck = {
		movedUp    = self:spawnObject(objectInfo, placableTile.x,   objectY+1, true, objectAreaType),
		movedDown  = self:spawnObject(objectInfo, placableTile.x,   objectY-1, true, objectAreaType),
		movedRight = self:spawnObject(objectInfo, placableTile.x+1, objectY,   true, objectAreaType),
		movedLeft  = self:spawnObject(objectInfo, placableTile.x-1, objectY,   true, objectAreaType),
	}
	local objectNotCloseToWall = true
	--Checks all the nudges and if any of them resulted in the object not spawning then the object won't spawn
	for key, objectWouldSpawn in pairs(objectsToCheck) do
		if not objectWouldSpawn then
			objectNotCloseToWall = false
		end
	end

	return objectNotCloseToWall
end

-----------------newSection - objectCreationMethods----------

--[[This actually spawns an object based on all information given.
It will first however perform various checks to see wheather the object can spawn. 
These include:
-Object is inside the map 	-Object is inisde another object   -Object is blocking a corridor
-Object is blocking a door  -Object is blocking a room 		   -Object is inside wall
It will spawn the object according to these and return wheather the object spawned.

You can also specify wheather you want the object to spawn or not. 
You may not want the object to spawn if you just want to check wheather the object could in theory spawn at the specified position.
]]
function SolidObjectsMaker:spawnObject(objectInfo, x, y, doNotSpawn, objectType, posOffsetX, posOffsetY)
	local object = Object(objectInfo, x, y, posOffsetX, posOffsetY)--Instantiates the object

	local spawnObject = true --Holds wheather the object can spawn or not

	--Performs various checks for wheather the object can spawn
	if self:checkIfObjectNotInsideMap(object) then --Prevents object from spawning outside of map
		spawnObject = false
		goto tryAgain --If object spawns outside of map skills all code to prevent errors
	elseif self:checkIfObjectIsBlockingDoor(object) then --prevents objects from blocking the door
		spawnObject = false
	elseif self:checkIfAnotherObjectIsDetectedInObject(object) then --Prevents objects from spawning inside each other
		spawnObject = false
	elseif self:checkIfObjectBlocksRoom(object) then --prevents object from blocking room entrance 
		spawnObject = false
	elseif self:checkIfObjectIsBlockingCorridor(object) then --prevents objects from blocking corridors
		spawnObject = false
	end

	--Checks if object is inside a wall/border from the houseTileMap
	--Certain object types are given leniency to this Eg:Objects that spawn against walls. 
	--So they aren't checked for being in a wall and only for map borders.
	if objectType == "Wall Object" or objectType == "Corner Floor Tiles" or objectType == "Window" then
		if self:checkIfObjectIsInsideWall(object,objectInfo,true) then 
			spawnObject = false
		end
	else --Checks everything else regularly
		if self:checkIfObjectIsInsideWall(object,objectInfo,false) then --Prevents object from spawning inside wall
			spawnObject = false
		end	
	end
	
	--If the object can spawn it places the objects in the table of objects.
	if spawnObject then
		if not doNotSpawn then --If doNotSpawn is specified then do not spawn obj.
			table.insert(self.objects[y], { Object = object })
		end
	end

	::tryAgain::

	--Returns whather the object spawned or not
	return spawnObject
end

--[[
Spawns multiple objects that don't perform collision checks on each other.
Use example: Multiple chairs spawning next to each other to look more natural.

The argument should be in this format.
multipleObjectsThatSpawn = {}
table.insert(multipleObjectsThatSpawn, {
objectInfo = object,
x = x, 
y = y
})
With each table.insert being a new object.
]]
function SolidObjectsMaker:spawnMultipleObject(InfoOnObjects)
	local objectsThatPassed = {} --Table containg objetcts that passed the collision checks (not in walls ect..)

	--Flips through all objects and listed and see wheather they could spawn at there current position. But not spawning them.
	for key, singleObjectsInfo in ipairs(InfoOnObjects) do
		if self:spawnObject(singleObjectsInfo.objectInfo, singleObjectsInfo.x, singleObjectsInfo.y, true) then
			--If they could spawn at there current position the algorithm remember the key for this object 
			table.insert(objectsThatPassed, key)
		end
	end

	--Matches the keys of object that could spawn to the object tables and then spawns all the objects that could spawn
	--We use this method so the objects don't perform collision checks on each other
	for _, objectThatPassedInfo in ipairs(objectsThatPassed) do
		for key, singleObjectsInfo in ipairs(InfoOnObjects) do
			--If the object was a part of the list of objects that could spawn then spawn it 
			if objectThatPassedInfo == key then
				local object = Object(singleObjectsInfo.objectInfo, singleObjectsInfo.x, singleObjectsInfo.y, singleObjectsInfo.offsetX, singleObjectsInfo.offsetY)

				table.insert(self.objects[singleObjectsInfo.y], { Object = object }) --Inserts object into table of objects
			end
		end
	end

end

--[[This is a function that is used to spawn more items on an object. Normally should be called when the object spawns.

It takes info from object defs that should hbe structured like this inside the objects defintions:

	--If you want this object to have other objects spawning on top of it then set this value to true
objectCanBePlacedOnThisObject = true,

	--This specifys the quads/tiles that objects can be placed on this object. The list can go on.
	--It is based on this object purely, so position in realtion to object, and calibrates the position later on/
tilesThatObjectsCanBePlacedOn = {{y=(num),x=(num)}, {y=(num),x=(num)}, },

	--This specifys objects that can be placed on the tiles above (the object is chosen at random from this list)
objectsToPlace = { 
{objectInfo = (object definition), offsetX = (num), offsetY = (num)}, 	--These offsets are added positional offsets that go on the object
{objectInfo = (object definition), offsetX = (num), offsetY = (num)},
},

	--This specifys the chance for the object to be placed on a tile. 1 means there is an absolout chance the object will be placed.
chanceForObjectToPlace = (num),

]]
function SolidObjectsMaker:spawnItemsToBePlaced(object, objectInfo)
	--This is a list of tiles in the object that the object can be placed on
	for k, tile in pairs(objectInfo.tilesThatObjectsCanBePlacedOn) do
		if tile.y == 1 and tile.x == 1 then goto skip end --We skip out because the first tile holds the actuall object so if that is replaced then the object won't exist on tileMap

		--Based on the specified tiles that the object can be placed on it gets the position in relation to the tile_map
		local positionsForObject = object:returnSpecifQuadPosition(tile.x, tile.y) 

		--Flips thrpugh the list of objects that can be placed on this object
		for k, singleObjectsInfo in pairs(objectInfo.objectsToPlace) do
			if math.random(1,objectInfo.chanceForObjectToPlace) == 1 then --has a random chance to choose an object to place based on chanceForObject to place
				local object = Object(singleObjectsInfo.objectInfo, positionsForObject.x, positionsForObject.y, singleObjectsInfo.offsetX, singleObjectsInfo.offsetY)
				table.insert(self.objects[positionsForObject.y], { Object = object }) --Inserts object into table of objects
				break
			end
		end

		::skip::
	end
end

-----------------newSection - objectRandomizationsMethods----------

--[[From a list of object informations it chooses a random object.]]
function SolidObjectsMaker:randomSpecifiedObject(objectTable)
	local objectElected --The object chosen
	local objectChosen = false  --wheather or not an object has been chosen

	repeat --repeats until an object has been shosen
		for key, object in pairs(objectTable) do
			if math.random(1,4) == 1 then
				objectElected = object
				objectChosen = true
			end
		end
	until objectChosen

	return objectElected
end

-----------------newSection - objectAnalysisFunctions----------
--[[I would say these functions and there names are rather self explanitory so I won't say much]]

function SolidObjectsMaker:checkIfObjectIsBlockingDoor(object)
	local IsBlockingDoor = false
	local objectPositions = object:returnTilePositions()

	--prevents self.objects from blocking the door
	for k, objectTile in pairs(objectPositions) do
		for k, EscapeWay in pairs(self.escapeWays) do

			local escapePositions = EscapeWay:returnTilePositions()
			for k, escapePosition in pairs(escapePositions) do
				--if the escape way position is the same as any of these object positions then object is blocking door
				if (escapePosition.y+1) ==  objectTile.y and escapePosition.x ==  objectTile.x then 
					IsBlockingDoor = true
				end
			end

		end
	end

	return IsBlockingDoor
end

function SolidObjectsMaker:checkIfObjectNotInsideMap(object)
	local notInsideMap = false

	local objectPositions = object:returnTilePositions()
	for k, objectTile in pairs(objectPositions) do

		--Check if the objects tiles would existr in the houseTileMap
		if not self.houseTileMap:tileExist(objectTile.y, objectTile.x) then
			notInsideMap = true
		end
	end

	return notInsideMap
end

--[[
An object can be characterised as blocking a corridor under 2 conditions:
(1)
It is only near 2 walls and those 2 walls are parralel to each other

(2)
It is touching less than 3 walls and it is touching walls who are diagonally paralel
However if it was touching 2 walls the diagonal must be along the interesection of the walls
Example:
| /               \ |
|/____    or    ___\|
Else it may miscalculate and beleive it is touching a corridor when really it is just touching its 2 walls
]]
function SolidObjectsMaker:checkIfObjectIsBlockingCorridor(object)
	local objectIsBlockingCorridor = false 

	local walls = {
	--Walls the object is touching
	wallAbove = false,
	wallBelow = false,
	wallRight = false,
	wallLeft = false,
	}

	local wallsDiagonal = {
	--Diagonal to the object
	wallLeftAbove = false,
	wallLeftBelow = false,
	wallRightAbove = false,
	wallRightBelow = false,
	}

	--Scans around each tile in the object to see wheather any walls are around it 
	--and if there are any tiles around it then it is catagorised and recorded as a
	--wall is next to it
	local allObjectTiles = object:returnTilePositions()
	for k, objectTile in pairs(allObjectTiles) do

		--We use this as a shorten version of the objectTile.axis so the code isn't to long
		local y = objectTile.y
		local x = objectTile.x

		--Gets all the tiles around this tile
		local tilesToCheck = {}
		if self.houseTileMap:tileExist(y+1,x) and self.houseTileMap:tileExist(y-1,x) and self.houseTileMap:tileExist(y,x+1) and  self.houseTileMap:tileExist(y,x-1) then
    		tilesToCheck = {
    		tileAbove = self.houseTileMap:checkForTileType(y+1, x  ),
    		tileBelow  = self.houseTileMap:checkForTileType(y-1, x  ),
    		tileRight = self.houseTileMap:checkForTileType(y  , x+1),
    		tileLeft  = self.houseTileMap:checkForTileType(y  , x-1),
    		tileLeftAbove  = self.houseTileMap:checkForTileType(y+1  , x-1),
    		tileLeftBelow  = self.houseTileMap:checkForTileType(y-1  , x-1),
    		tileRightAbove  = self.houseTileMap:checkForTileType(y+1  , x+1),
    		tileRightBelow  = self.houseTileMap:checkForTileType(y-1  , x+1)
    		}
		end
		--local tileMain  = self.houseTileMap:checkForTileType(y,x)
		--local areaType = self.houseTileMap:checkForTileType(objectTile.y, objectTile.x)


		--catagorises the tiles around the tile we are examining
		for tileCheckedFor, tileType in pairs(tilesToCheck) do
			--checks if the tile we are checking for is a wall
			if tileType == "wall" or tileType == "border" then 
				--catagorising walls
				if tileCheckedFor == "tileAbove" then
					walls.wallAbove = true
				elseif tileCheckedFor == "tileBelow" then
					walls.wallBelow = true
				elseif tileCheckedFor == "tileRight" then
					walls.wallRight = true
				elseif tileCheckedFor == "tileLeft" then
					walls.wallLeft = true

				--Anaysis for diagonal walls
				elseif tileCheckedFor == "tileLeftAbove" then
					wallsDiagonal.wallLeftAbove = true
				elseif tileCheckedFor == "tileLeftBelow" then
					wallsDiagonal.wallLeftBelow = true
				elseif tileCheckedFor == "tileRightAbove" then
					wallsDiagonal.wallRightAbove = true
				elseif tileCheckedFor == "tileRightBelow" then
					wallsDiagonal.wallRightBelow = true
				end
			end--End of wall check
		end --End of analysing everything around this tile

	end

	--Checks how many walls are around the object
	--We only check walls which are not diaganol because diagonal walls will just be an extra wall
	--Example if the player is a wall they will most likely be diagonal to it
	local wallsNearObjectTile = 0
	for wallType, wallPresent in pairs(walls) do
		--checks if the tile we are checking for is a wall
		if wallPresent then 
			wallsNearObjectTile = wallsNearObjectTile + 1
		end
	end

	--If the object only has 2 walls near it, and these walls are parralel then
	--it is blocking a corridor
	if wallsNearObjectTile == 2 then
		--checks for parrel walls
		if (walls.wallAbove and walls.wallBelow) or (walls.wallRight and walls.wallLeft) then
			objectIsBlockingCorridor = true
		end
	end

	--It object is near 2 walls and it is near walls who are diagonally paralel
	--There is a corridor
	--However the diagonal must be along the interesection of the walls
	--Example:
	--| /               \ |
	--|/____    or    ___\|
	--Else it may miscalculate and beleive it is touching a corridor when really it is just touching its 2 walls
	if wallsNearObjectTile == 2 then
		--Examines for diagonally parallel walls who are topRight and LeftBottom
		if (walls.wallAbove and walls.wallRight) or (walls.wallBelow and walls.wallLeft) then
			if (wallsDiagonal.wallRightAbove and wallsDiagonal.wallLeftBelow) then
				objectIsBlockingCorridor = true
			end
		--Examines for diagonally parallel walls who are RightBottom and TopLeft
		elseif (walls.wallAbove and walls.wallLeft) or (walls.wallBelow and walls.wallRight) then
			if (wallsDiagonal.wallRightBelow and wallsDiagonal.wallLeftAbove) then
				objectIsBlockingCorridor = true
			end
		end
	end

	--It is near less than 2 walls and it is touching walls who are diagonally paralel
	--It is blocking a corridor
	if wallsNearObjectTile < 2 then
		--checks for daigonal parrel walls
		if (wallsDiagonal.wallRightAbove and wallsDiagonal.wallLeftBelow) or (wallsDiagonal.wallRightBelow and wallsDiagonal.wallLeftAbove) then
			objectIsBlockingCorridor = true
		end
	end

	return objectIsBlockingCorridor
end

function SolidObjectsMaker:checkIfObjectIsInsideWall(object,objectInfo,spawningUnderWall)
	local wallDetected = false

	local objectPositions = object:returnTilePositions()
	for k, objectTile in pairs(objectPositions) do

		--For all the tile's of this object, it checls its psotion on the objects tileMap and see what tile exists there
		local areaType = self.houseTileMap:checkForTileType(objectTile.y, objectTile.x) 

		--If it spawns under a wall there is leniency with it being on a wall or border
		if spawningUnderWall then
			if objectInfo.doNotrenderHigherOnWall == true then
				if areaType == 'border' or areaType == 'wall' then
					wallDetected = true
				end
			else
				if areaType == 'border' then
					wallDetected = true
				end
			end

		else --else if it normal and on any wall or border then a  wall is detected
			if areaType == 'border' or areaType == 'wall' then
				wallDetected = true
			end
		end

	end

	return wallDetected
end

function SolidObjectsMaker:checkIfAnotherObjectIsDetectedInObject(object)
	local objectPositions = object:returnTilePositions()
	local anotherObjectDetected = false

	--Prevents self.objects from spawning inside each other
	--Looks through this self.objects positions
	for k, mainObjectsTile in pairs(objectPositions) do
		--looks through all the other self.objects already added
    	for y = 1, self.mapHeight do
			for x = 1, self.mapWidth do
				--Gets the already added obj
				local tile = self.objects[y][x]
	    		
	    		if tile then
	    			--Gets the position from this already added object
		    		local otherObjPositions = tile.Object:returnTilePositions()

		    		--for each position set it compares it with the current tiles position set
		    		for k, otherObjectPos in pairs(otherObjPositions) do
			    		if otherObjectPos.y == mainObjectsTile.y and otherObjectPos.x == mainObjectsTile.x then
			    			anotherObjectDetected = true
			    		end
			    	end
			    end

		    end
    	end
   	end

   	return anotherObjectDetected

end

function SolidObjectsMaker:checkIfObjectBlocksRoom(object)
	local objectPositions = object:returnTilePositions()
	local objectBlocksRoom = false

	for k, ObjectTile in pairs(objectPositions) do

		for k, roomOpeningTile in pairs(self.roomOpeningPositions) do --looks through the room opening positions

			local roomOpeningTileY = (roomOpeningTile.y - 3) --starts at a y a few tiles down from the room opening for good measure
			--examines a few tiles up and down the y position of the room opening and makes sure the object isn't there
			for i = 1, 4 do 
			roomOpeningTileY = roomOpeningTileY + 1
				if ObjectTile.x == roomOpeningTile.x and ObjectTile.y == roomOpeningTileY then --Check if this objects tiles overlap with the room opening tiles
					objectBlocksRoom = true
				end
			end

		end
	end

	return objectBlocksRoom
end

-----------------newSection - houseAnalysisFunctions----------

--[[This returns specified tilePositions from the house. Returns as a table.

The areaType can be the following:
	Underneath Wall Tile --If there are 2 walls in a row we can deduce under the wall there will be a floor
	Floor Tiles --The tile is a floor and so is the tile behind it so that this tile won't be confused with wall tiles
	Middle of Floor Tiles --A tile that is 1 tiles away from all walls or borders
	Corner Floor Tiles --A tile thats on a floor and has walls on at least 2 sides of the tile, that is a corner
	Bottom of Floor Tiles --A tile that has a border underneath it 


]]
function SolidObjectsMaker:returnSpecifiedHouseTilePositions(areaType)
	local positiondOfTileType = {}

	--Checks for areas undrneath walls
	if areaType == 'Underneath Wall Tiles' then
	    for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		--For it to be underneath a wall the main tile must be a floor and the tile above should be a wall.
	    		--However to make sure it does not block corridors we also check to make sure that the tile bellow is also a floor.

	    		--checks if the current tile we are examining is a floor tilr
				local tileType1 = self.houseTileMap:checkForTileType(y, x)
	    		if tileType1 == "floor" then
	    			--check if the tile above this one is a wall
	    			local tileType2 = self.houseTileMap:checkForTileType(y - 1, x)
	    			if tileType2 == "wall" then
	    				--checks if the tile underneath is also a floor to prevent from blocking corridors.
	    				local tileType3 = self.houseTileMap:checkForTileType(y+1, x)
	    				if tileType3 == "floor" then
	    					
	    					table.insert(positiondOfTileType, {x = x, y = y}) 
	    				end

	    			end

	    		end

	    		--[[ Old code <PERMISSION TO DELETE GRANTED>
	    		local tileType1 = self.houseTileMap:checkForTileType(y, x)
	    		if tileType1 == "wall" then
	    			local tileType2 = self.houseTileMap:checkForTileType(y + 1, x)
	    			if tileType2 == "wall" then
	    				table.insert(positiondOfTileType, {x = x, y = (y+2)})
	    			end
	    		end]]

	    	end
	    end

	--Checks for areas that are only floor
	elseif areaType == 'Floor Tiles' then
	    for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		--for the tile to be classified as a floor tile it must be away from any walls so it's not confused with underneath wall tiles
	    		local tileType1 = self.houseTileMap:checkForTileType(y, x)
	    		if tileType1 == "floor" then
	    			local tileType2 = self.houseTileMap:checkForTileType(y-1, x)
	    			if tileType2 == "floor" then
	    				table.insert(positiondOfTileType, {x = x, y = y})
	    			end
	    		end

	    	end
	    end
	
	--A tile that is 1 tiles away from all walls or borders
	elseif areaType == 'Middle of Floor Tiles' then
	    for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		--on this specified tile it gets a tile that is shifted around on all sides and if any is detected as a wall then it is not in the middle
	    		local tilesToCheck = {}
	    		--Makes sure the shifted tiles aren't outside the map boundary else an error will occur when retreiving type.
	    		if self.houseTileMap:tileExist(y+1,x) and self.houseTileMap:tileExist(y-1,x) and self.houseTileMap:tileExist(y,x+1) and  self.houseTileMap:tileExist(y,x-1) then
		    		tilesToCheck = {
		    		tileAbove = self.houseTileMap:checkForTileType(y+1, x  ),
		    		tileBelow  = self.houseTileMap:checkForTileType(y-1, x  ),
		    		tileRight = self.houseTileMap:checkForTileType(y  , x+1),
		    		tileLeft  = self.houseTileMap:checkForTileType(y  , x-1),
		    		tileLeftAbove  = self.houseTileMap:checkForTileType(y+1  , x-1),
		    		tileLeftBelow  = self.houseTileMap:checkForTileType(y-1  , x-1),
		    		tileRightAbove  = self.houseTileMap:checkForTileType(y+1  , x+1),
		    		tileRightBelow  = self.houseTileMap:checkForTileType(y-1  , x+1)
		    		}
	    		end

	    		local onlyFloors = true --wheather there have only been flores detected
	    		local tileMain  = self.houseTileMap:checkForTileType(y,x)
	    		
	    		--goes thrpough all tiles to check which just have been the original tile shifted around, and oif any are walls then it isn't a midde
	    		for key, tile in pairs(tilesToCheck) do
		    		if tile == "wall" or tile == "border" then
		    			onlyFloors = false
		    		end
		    	end
		    	
		    	--If its only been floors then add it
	    		if tileMain == "floor" and onlyFloors then
	    			table.insert(positiondOfTileType, {x = x, y = y})
	    		end

	    	end
	    end
	
	--A tile thats on a floor and has walls on at least 2 sides of the tile, that is a corner
	elseif areaType == 'Corner Floor Tiles' then
	    for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		--list of tiles to check which are the original tile but shifted around
	    		local tilesToCheck = {}
	    		if self.houseTileMap:tileExist(y+1,x) and self.houseTileMap:tileExist(y-1,x) and self.houseTileMap:tileExist(y,x+1) and  self.houseTileMap:tileExist(y,x-1) then
		    		tilesToCheck = {
		    		tileAbove = self.houseTileMap:checkForTileType(y-1, x  ),
		    		tileDown  = self.houseTileMap:checkForTileType(y+1, x  ),
		    		tileRight = self.houseTileMap:checkForTileType(y  , x+1),
		    		tileLeft  = self.houseTileMap:checkForTileType(y  , x-1)
		    		}
	    		end

	    		--if the tileAbove and below this one are walls, and the tiles to the right and left are floors, then this is most likely blocking a corridor. 
	    		--Because that would mean it is blocking a space the player could walk too. So we skip this to prevent corridor blocking.
	    		if tilesToCheck.tileAbove == "wall" and tilesToCheck.tileDown ==  "border" and tilesToCheck.tileRight ==  "floor" and tilesToCheck.tileLeft ==  "floor" then
	    			goto skip
	    		end

	    		local numberOfWallsDetected = 0
	    		local tileMain  = self.houseTileMap:checkForTileType(y,x)
	    		
	    		for key, tile in pairs(tilesToCheck) do
		    		if tile == "wall" or tile == "border" then
		    			numberOfWallsDetected = numberOfWallsDetected + 1
		    		end
		    	end
		    	
		    	--a wall count of 2 or more means it is a corner tile.
	    		if tileMain == "floor" and numberOfWallsDetected >= 2 then
	    			table.insert(positiondOfTileType, {x = x, y = y})
	    		end

	    		::skip::
	    	end
	    end
	
	--A tile that has a border underneath it
	elseif areaType == 'Bottom Floor Tiles' then
	    for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		local tileType1 = self.houseTileMap:checkForTileType(y, x)
	    		if tileType1 == "floor" then

	    			local tileType2 = self.houseTileMap:checkForTileType(y+1, x)
	    			if tileType2 == "border" then
	    				table.insert(positiondOfTileType, {x = x, y = y})
	    			end

	    		end

	    	end
	    end

	--Base wall is characterised as the first wall encountered on the y axis, because nornally there are no walls higher than it
	elseif areaType == 'Upper Base Wall' then
		local baseWallFound = false
		for y = 1, self.mapHeight do
	    	for x = 1, self.mapWidth do

	    		--on the first set of wall encountered it marks this whole x axis as a base wall and then stops searching since we are looking for
	    		--the first set of walls encountered.
	    		local tileType1 = self.houseTileMap:checkForTileType(y, x)
	    		if tileType1 == "wall" then
	    			baseWallFound = true
	    			table.insert(positiondOfTileType, {x = x, y = y})
	    		end

	    	end

	    	if baseWallFound then
	    		goto skip
	    	end
	    end

	end

	::skip::
	return positiondOfTileType
end

-----------------newSection - DEVELOPER METHODS----------

--highlights an object
function SolidObjectsMaker:pinPointObj(object)
	self.renderObject = object
end

--call this to render the inpointed obj
function SolidObjectsMaker:developerRender()
	if self.renderObject then
		local allObjectTiles = self.renderObject:returnTilePositions()
		for k, objectTile in pairs(allObjectTiles) do
			love.graphics.setColor(255,255,255,180)
			love.graphics.rectangle('fill', objectTile.x * 16, objectTile.y * 16, 16, 16)
		end
	end
end
