HouseMaker = Class{}

--[[
*General Information*---------------------------------------------------------------------
This is the house maker class. It is used to help make a houses foundation.

How the house maker works is that as you initialise this class a tile_map with a houses base is made.
From then on you can call functions to modify the houses base. Eg: add more rooms ect...
Once that is done call HouseMaker:ReturnHouse() and the houses tile_map will be returned, with it being returned as an object from the tile_map class.
It will thus be ready for use and you would only have to call TileMap:render()

The functions to modify a house can be split into 2 catagories intelligent functions and more-hands-on functions.
Intelligent functions do all the generation for you where as more-hands-on is manuall and a bit complicated.

*Intelligent Functions to modify a house*---------------------------------------------------------------------
(1)
	--Inside a house there are multiple rooms, which are walled area's within the house.
	--This function is the brain generates these rooms in the house based on how much space there is.
	--It does this by calculating and calling appropriate functions needed to perform this task.
	--(The actuall making of the rooms is handled by the buildRoom function.)
HouseMaker:ProcedurallyGenerateRooms()
	
*more-hands-on Functions to modify a house*---------------------------------------------------------------------

How rooms are made:
Rooms and walls are made by HouseMaker:BuildWallOnyAxis and HouseMaker:BuildWallOnxAxis().
These functions use a table of coordinates and connect walls to where these coordinates are. Example:
	
	--The mnumber in the table that the algrorythm is focusing on
	--which the walls will be connected to, as it will lead to the coorect index from the table.
	--Walls will connect to the current room num set of points! So they will index into the table at current room num number.
self.currentRoomNum = (num) 

	--Table that holds the coordinates
self.roomPoints = {}

	--The coordinates for each index in the table are defined as so
self.roomPoints[self.currentRoomNum] = {
	bottomY = (num), --lower y position; where a horizontal wall will spawn, and a vertical wall will end
	topY = (num), --The higher y position where a vertical wall would start
	X = (num), --The xposition the walls will meet at
}
(I reccomend you rework this system if you have free time)

Each function and how it works:
Once you have defined the coordinatess you may call these functions to build the walls.

	--Builds a vertical wall from the topY position down to the bottomY position, on the X defined. The wall ends in a transition to side view wall.
	--There can be special wall types, hhowever this isn't mandatory
		"bottom corner" - This wall is one that is expected to touch the bottom of the map, so the transition to normall wall is purposefully omitted
HouseMaker:BuildWallOnyAxis(wallType)

	--Builds a horizontal wall from either the right or left side of the map to the defined X point, on the bottomY/topY y position.
	--The wallConnectionType determines wheather the wall connects from the right or left. Use these strings:
		"right"
		"left"
	--The doorOpening means wheather there should be a whole in the wall, like a door. This is a bool value.
	--wallType can be one of two things; They determine how the wall looks:
		*If top is chosen the wall will spawn at topY, and if bottom is chosen the wall will spawn at bottomY*
		"top" 	 --This is a wall that usually above a vertical wall made purposefully to look like it's behind another wall
		"bottom" --This wall looks like it's infront of another wall
HouseMaker:BuildWallOnxAxis(wallConnectionType, doorOpening, wallType) 
]]

function HouseMaker:init(houseTexture, houseInfo, mapTileHeight, mapTileWidth)
	--Initialises key factors need for the house
	self.mapWidth = mapTileWidth
    self.mapHeight = mapTileHeight

    --The texture of the house
    self.houseTextureWalls = houseTexture.walls
    self.houseTextureFloors = houseTexture.floors
    self.houseTexture = houseTexture

    self.houseInfo = houseInfo

    --Keeps track of how many rooms are in this room
    self.currentRoomNum = 0
    self.roomOpenings = {}

    self.ROOM_WIDTH_MIN = 5
	self.ROOM_WIDTH_MAX = 4

    self:MakeHouseBase()
end

--Returns all the tiles which would have been developed from the other house functions
function HouseMaker:ReturnHouse() 
	return {house = Tile_map(self.houseTiles, "tiles", self.mapHeight, self.mapWidth), roomOpeningPositions = self.roomOpenings}
end

--[[This is the brain behind room generation.
Rooms being walled of area's within a house.

This function will call all the correct functions for making the rooms
and calculate if we can add more rooms based on the space available.
]]
function HouseMaker:ProcedurallyGenerateRooms()
	--This is a table that holds the core location info for each room.
	--This includes: RoomCorners, Xpositions and Ypositions.
	self.roomPoints = {}

	--The shed house type has many sections going throughout the whole house. 
	--The sections are just the house being devided up by vertical walls, which span the height of the house.
	--These sections are of equal distance from each other, with there being a door like opening in each sections. The ammount is dependant on room size.
	if self.houseInfo.type == "shed" then
		--chooses the space between vertical walls
		local spaceBetweenRooms = math.random(8,10)
		--chooses the ammount of sections there will be, which is dependant on the size of the room
		local numberOfRoomSections = math.floor(self.mapWidth/spaceBetweenRooms) --we use math.floor because if we overestimate walls then a wall can spawn out of the map bounds

		--instantiates all vertical walls making the room devided up into sections.
		for sectionNum = 1,numberOfRoomSections do 
			--if crossSectionNum == numberOfRoomCrossections then break end --the last wall would spawn where the end of the map is (the border), which is unnesary
			self.currentRoomNum = 1
			--chooses where the door like opening will be for each vertical wall
			local roomGap = math.random(5, self.mapHeight-1)

			self.roomPoints[self.currentRoomNum] = {
				bottomY = self.mapHeight-1, 
				topY = 2, 
				X = sectionNum*spaceBetweenRooms, --makes the wall spaced out
			}
			
			--if the wall is at the end it will not be clased be cause it causes a bug where the player can go outside the map
			if not (self.roomPoints[self.currentRoomNum].X == self.mapWidth) then
				self:BuildWallOnyAxis("bottom corner", roomGap) --builds vertical wall
			end

		end

		--since this is how the shed is made we are no longer interested in any further logic and thus the house generation is finnished
		goto skipFunction
	end

	if self.houseInfo.noRooms then goto skipFunction end

	--If this is the first room made it will build a top corner room 
	if self.currentRoomNum == 0 then
		--Since a new room is being built the room number increases
		self.currentRoomNum = self.currentRoomNum + 1
		self:BuildRoom("Upper Corner Room")
	end

	--After building the first room if there is more space available then more rooms will be added
	if self.mapHeight - self.roomPoints[self.currentRoomNum].bottomY > 5 then 
		repeat
			--Since a new room is being built the room number increases
			self.currentRoomNum = self.currentRoomNum + 1
			--Chooses which type of room to build randomly
			if math.random(1,3) == 1 then
				self:BuildRoom("Wall Parter")
			else
				self:BuildRoom("Bottom Corner Room")
			end
		--If there is still more space left after building that room then we make another room
		until self.mapHeight - self.roomPoints[self.currentRoomNum].bottomY < 5
	end 

	::skipFunction::
end 

--[[Based on type given this will call the appropriate
function in the correct order to create the desired room.
]]
function HouseMaker:BuildRoom(roomType)
	--This is a room characterised by being in top corner of a house
	if roomType == "Upper Corner Room" then
		--First sets out the rooms coordinates with the points table
		self.roomPoints[self.currentRoomNum] = {
		bottomY = math.random(2 +  self.ROOM_WIDTH_MIN, self.mapHeight - self.ROOM_WIDTH_MAX), 
		topY = 1,
		X = math.random(2, self.mapWidth - 1),
		}
    
    	--chooses which side of the house the room should be attached to
	    local wallConnection = math.random(1,2) == 1 and "right" or "left"

	    --Buils wall on the x axis then the y axis to give it a corner room look
	    self:BuildWallOnyAxis()
	    --Makes the x axis wall such that it is a wall that has an opening
	    --and appears to be on the bottom of a room
	    self:BuildWallOnxAxis(wallConnection, true, "bottom")

	    --Chance for a second room to be made next to this room
	    --To makre the second room it's just putting another wall on going connecting the other side of the room, with an opening in it
	    if math.random(1,3) == 1 then
	    	self.currentRoomNum = self.currentRoomNum + 1

	    	local bottomY =  self.roomPoints[self.currentRoomNum-1].bottomY
	    	self.roomPoints[self.currentRoomNum] = {
			bottomY = bottomY, 
			topY = bottomY+1,
			X = self.roomPoints[self.currentRoomNum-1].X,
			}

			if wallConnection == "right" then
				wallConnection = "left"
			else --the wall conection would be left
				wallConnection = "right"
			end

	    	self:BuildWallOnxAxis(wallConnection, true, "bottom")
	    end

	--This "room" creates a wall that goes across the middle of the house with varying lengths
	--It is more desighned to split a room in half
	elseif roomType == "Wall Parter" then
		--Gets the walls coordinates
		--Makes sure the room is 2 tiles down from the last generated room so the player can walk between rooms easily
		local bottomY = math.random(self.roomPoints[self.currentRoomNum-1].bottomY + 3, self.mapHeight - self.ROOM_WIDTH_MAX)
		self.roomPoints[self.currentRoomNum] = {
		bottomY = bottomY, 
		topY = bottomY + 1,
		X = math.random(1, self.mapWidth - 1),
		}
    
    	--chooses which side of the house the room should be attached to
	    local wallConnection = math.random(1,2) == 1 and "right" or "left"
	    --Just builds a wall since that is all the wall parter is
	    --It does not generate a hole because the wall parters coordinates are already desighned to have a gap
		self:BuildWallOnxAxis(wallConnection, false, "bottom")

	--This is a room characterised by being on the bottom corner of a house
	elseif roomType == "Bottom Corner Room" then
		--Gets the walls coordinates
		--Makes sure the room is 2 tiles down from the last generated room so the player can walk between rooms easily
		local topY = math.random(self.roomPoints[self.currentRoomNum-1].bottomY + 3, self.mapHeight - self.ROOM_WIDTH_MAX)
		self.roomPoints[self.currentRoomNum] = {
		bottomY = self.mapHeight - 1, 
		topY = topY,
		X = math.random(2, self.mapWidth - 1),
		}
    
    	--chooses which side of the house the room should be attached to
	    local wallConnection = math.random(1,2) == 1 and "right" or "left"

	    --Builds a wall on the x axis first so that it will make an illsuion of being behind the y axis wall
	    self:BuildWallOnxAxis(wallConnection, true, "top")
	    self:BuildWallOnyAxis("bottom corner")
	end
	
end

--[[This create the base of a house. So floors and walls.
The width and height of the house are dependant on virtual screen size
and how many tiles can fit in the screen.]]
function HouseMaker:MakeHouseBase()
	self.houseTiles = {}

	--Generates base wall
    for y = 1, self.mapHeight do
        table.insert(self.houseTiles, {})

        for x = 1, self.mapWidth do
        	local texture = self.houseTextureWalls
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = HOUSE_WALL_TILE_IDs["TR_border"]
            elseif x == 1 and y == self.mapHeight then
                id = HOUSE_WALL_TILE_IDs["BR_border"]
            elseif x == self.mapWidth and y == 1 then
                id = HOUSE_WALL_TILE_IDs["TL_border"]
            elseif x == self.mapWidth and y == self.mapHeight then
                id = HOUSE_WALL_TILE_IDs["BL_border"]
            
            -- random left-hand walls, right walls, top, bottom, and floors
        	elseif x == 1 then
        		id = HOUSE_WALL_TILE_IDs["R_border"]
        	elseif x == self.mapWidth then 
        		id = HOUSE_WALL_TILE_IDs["L_border"]
        	elseif y == self.mapHeight then
        		id = HOUSE_WALL_TILE_IDs["B_border"]
            elseif y == 1 then
                id = HOUSE_WALL_TILE_IDs["Upper_border_wall"]
            elseif y == 2 then
                id = HOUSE_WALL_TILE_IDs["Lower_border_wall"]
            else
                id = HOUSE_FLOOR_TILE_IDs["Unshaded_floor"]
                texture = self.houseTextureFloors
            end
            
            table.insert(self.houseTiles[y], {
                Tile = Tile(x, y, texture, id)
            })
        end
    end

end

--[[Makes a wall along y axis (vertically).

Because of the top down perspective these walls are for
the most part all white tiles. However when the y axis
wall is comming to an end it transitions the tilles of
an x asis wall that connects to the ceiling.

A waltype can be specified to make it look a certain way.
]]
function HouseMaker:BuildWallOnyAxis(wallType, wallGapYPos)

	--Makes wall for a room thats in the bottom corner
	--This is a specsialised wall, since the wall is connecting
	--to the bottom the transition back to regular wall is purposely omited
	--to have the illusion that the wall is connecting directly to the rooms borders.
	if wallType == "bottom corner" then
		for y = self.roomPoints[self.currentRoomNum].topY - 1, self.roomPoints[self.currentRoomNum].bottomY do
	    	local id

	    	if y == self.roomPoints[self.currentRoomNum].topY-1 then 
	    		id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall_Top-Corner"]
	    	elseif y == self.roomPoints[self.currentRoomNum].bottomY - 1 then
	    		id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall"]
	    	else
	    		id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall"]
	    	end

	    	self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureWalls, id)
	    end

	else --Regular y axis wall with a transition to regular wall
	    for y = self.roomPoints[self.currentRoomNum].topY, self.roomPoints[self.currentRoomNum].bottomY do
	    	local id

	    	if y == 1 then 
	    		id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall_Top-Border"]
	    	elseif y == self.roomPoints[self.currentRoomNum].bottomY then
	    		id = HOUSE_WALL_TILE_IDs["Lower_Room_Corner_Wall"]
	    	elseif y == self.roomPoints[self.currentRoomNum].bottomY - 1 then
	    		id = HOUSE_WALL_TILE_IDs["Upper_Room_Corner_Wall"]
	    	else
	    		id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall"]
	    	end

	    	self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureWalls, id)
	    end
	end

	--wallGapYPos means there is a gap in the vertical wall where there will be floor. This gap is at a specified y pos. 
	--A gap means there is a opening in the wall, just as there are holes in horizontal walls for room openings. 
	--Note: It must make a transition back to normal wall 2 spaces before the gap.
	if wallGapYPos then
		for y = self.roomPoints[self.currentRoomNum].topY, self.roomPoints[self.currentRoomNum].bottomY do --flips through the wall
			local id

			--2 tiles before the gap it transitions back to regular wall, with it makingthe upper wall
			if y == wallGapYPos-2 then
				id = HOUSE_WALL_TILE_IDs["Upper_Room_Corner_Wall"]
				self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureWalls, id)

			--1 tile before the gap it transitions back to regular wall, with it making the lower wall
			elseif y == wallGapYPos-1 then
				id = HOUSE_WALL_TILE_IDs["Lower_Room_Corner_Wall"]
				self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureWalls, id)

			--1 tile after the gap it makes the wall look more crisp by having a texture that gives the appearance of the wall being cut off from the rest.
			elseif y == wallGapYPos+1 then
				id = HOUSE_WALL_TILE_IDs["Ceiling_Room_Wall_Top-Corner"]
				self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureWalls, id)

			--at the gap position it makes the wall into floor
			elseif y == wallGapYPos then
				id = HOUSE_FLOOR_TILE_IDs["Unshaded_floor"]
		   		self.houseTiles[y][self.roomPoints[self.currentRoomNum].X].Tile = Tile(self.roomPoints[self.currentRoomNum].X, y, self.houseTextureFloors, id)
			end

		end
	end

end

--[[This creates a wall along the x axis (horizontal walls).
A type can be specified.

How the walls work is that the x axis walls are 2 tiles thick
because of how the assests are desighned with there being an 
upper and lower wall for each xAxis wall set.

If walls are connected to the right or left side of the room is chosen in the parampeters. 
]]
function HouseMaker:BuildWallOnxAxis(wallConnectionType, doorOpening, wallType) 
	--Based on if the wall is connecting to the right or left
	--We adjust some key variables, to make the walls connect in the proper direction
	local edge1
	local edge2
	local incrimentType
	if wallConnectionType == "right" then
		edge1 =  self.mapWidth - 1
		edge2 = self.roomPoints[self.currentRoomNum].X + 1
		incrimentType = -1
	elseif wallConnectionType == "left" then
		edge1 =  2
		edge2 = self.roomPoints[self.currentRoomNum].X - 1
		incrimentType = 1
	end

	--The wall on the X can be a top wall or bottom wall, which bassiacally means does the wall:go above a verticle wall or below it. 
	local wallY
	if wallType == "bottom" then
		wallY = self.roomPoints[self.currentRoomNum].bottomY
	elseif wallType == "top" then
		wallY = self.roomPoints[self.currentRoomNum].topY
	end

	--Connects wall to the roomX based on key variables
	--Makes the upper and higher walls bassically and connects them to the x axis.
	for y = wallY, wallY - 1, -1 do --Does it on llower and upper wa;;
		for x = edge1, edge2, incrimentType do  --Makes walls between the edjes that have been defined
	   		local id

	   		if y == wallY - 1 then
	   			id = HOUSE_WALL_TILE_IDs["Upper_Room_Wall"]
	   		elseif y == wallY then
	   			id = HOUSE_WALL_TILE_IDs["Lower_Room_Wall"]
	   		end

	    	self.houseTiles[y][x].Tile = Tile(x, y, self.houseTextureWalls, id) --inserts the wall into the table of tiles
		end
	end

	--Makes a door opening in the wall
	if doorOpening then
		--picks a door opening position, the randomisation varies depending on direction
		local doorOpeningX
		if wallConnectionType == "right" then
		 	doorOpeningX = math.random(self.roomPoints[self.currentRoomNum].X + 1, self.mapWidth - 1)
		 elseif wallConnectionType == "left" then
		 	doorOpeningX = math.random(self.roomPoints[self.currentRoomNum].X - 1, 1)
		end

		--Records this room opening
		self.roomOpenings[self.currentRoomNum] = {x = doorOpeningX, y = wallY}

		--removes tiles based on opening position
		for y = wallY, wallY - 1, -1 do --Does it on the lower and upper wall
		    for x = edge1, edge2, incrimentType do --Itterates through all the walls in the set of walls we have
		   		local id
		   		--Removes the tiles from door opening chosen
		   		if x == doorOpeningX then
		   			id = HOUSE_FLOOR_TILE_IDs["Unshaded_floor"]
		   			self.houseTiles[y][x].Tile = Tile(x, y, self.houseTextureFloors, id) --changes the tile

		   		--changes wall tiles near the opening to make the opening look realistic
		   		elseif x == doorOpeningX - 1 then --to the left of the opening
		   			if y == wallY - 1 then
			   			id = HOUSE_WALL_TILE_IDs["Upper_Room_Edge-Wall-right"]
			   		elseif y == wallY then
			   			id = HOUSE_WALL_TILE_IDs["Lower_Room_Edge-Wall-right"]
			   		end
		   			self.houseTiles[y][x].Tile = Tile(x, y, self.houseTextureWalls, id) --changes the tile
		   		elseif x == doorOpeningX + 1 then --to the right of the opening
		   			if y == wallY - 1 then
			   			id = HOUSE_WALL_TILE_IDs["Upper_Room_Edge-Wall-left"]
			   		elseif y == wallY then
			   			id = HOUSE_WALL_TILE_IDs["Lower_Room_Edge-Wall-left"]
			   		end
		   			self.houseTiles[y][x].Tile = Tile(x, y, self.houseTextureWalls, id) --changes the tile
		   		end

		   	end
		end
	end

end
