--[[
LIST OF PARAMETERSS;

*General Information*---------------------------------------------------------------------
This contains all definitons for the objects found inside a house. These definitons are quite powerfull and these tell the game 
the quads for the object along with it's size and it even will tell the game where to place the object.

This game is completly tile based, because of this the objects are too. So in procedural generation it scan a tile_map of the house and then
places the object in a seperate house objects tile_map. 

Now you might be asking, how did you get objects with a width/height of more than one to be tile based?
Well first I made it so that on the tile_map the reall object only takes up one tile. However when this 1 tile is rendered
it renders the whole object, in the Object class. It does this by taking the width and height and sequentially for each width/height it moves
the object on the x/y axis by one tile alonng with changing the quadX/quadY by this value and rendering. Giving the illusion of a whole object being there. 

An advantage of this system is that another object can go on top of what appears to be that object as long as it's not on the origin tile of the object.
The origin tile being the tile that contains the object. 

*Sections*---------------------------------------------------------------------
There are a ton of dfferent object types so we devided it into sections:
SOLID_GAME_OBJECTS_MISC
PLACABLE_GAME_OBJECT_DEFS
ESCAPE_GAME_OBJECT_DEFS
SOLID_GAME_OBJECT_DESKS
SOLID_GAME_OBJECTS_BEDS 
SOLID_GAME_OBJECTS_SHELVES
SOLID_GAME_OBJECTS_TABLES
SOLID_GAME_OBJECTS_CANVAS
SOLID_GAME_OBJECTS_CHAIRS
SOLID_GAME_OBJECTS_INSTRUMENTS

*List of all definitions without explination*---------------------------------------------------------------------
quadX = (num),
quadY = (num),
tileWidth = (num),
tileHeight = (num),
PositionoffsetX = (num), 
PositionoffsetY = (num),

spawnLocationInfo = (string), "Spawn Underneath Wall" -"Corner Floor Tiles"	-"Middle of Floor Tiles" - 'Bottom Floor Tiles'
doNotrenderHigherOnWall = (bool),
placeMuchHeigherOnWalls = (bool),
notSolid = (bool),
tilesThatObjectCanCollideWith = {{y=(num),x=(num)}, {y=(num),x=(num)}, },
renderPlayerUnderObject = (bool),

stealable = (bool),
objectsWorth = (int),
name = (string),

opaque = (bool),
canNotBeDestroyed = true,

*List of all definitons and how to use them*---------------------------------------------------------------------
	--Quads are calculated on these values, it makes it easier so you only need to find the x and y of the quad
	--Remember quads are split into 16x16 parts so quadY = 1(16pixels on y), QuadX = 2(32 pixels on x)
quadX = (num), --This is the quad of the object on the x axis
quadY = (num), --This is the quad of the object on the y axis

	--Objects are made such that they only take up one tile, however when this one tile is rendered it renders the whole object based on width and height
	--Example:
	--So if your object is on x = 1, y = 2 and has a width = 1, height = 2, and it's quads are Quady= 5, QuadX= 10
	--When your object is rendered it will first render QuadY followed by QuadX, at position x1 and y2.
	--Then it will check your width and height, since your height is 2 it will render the next part of the object
	--At x1, y2 + self.height, and Quadx10 and Quady + self.height render tile making the illusion of a complete object.
tileWidth = (num), --This is the objects width
tileHeight = (num), --This is the objcts height

	--This offsets the objects actuall position, so if y=2 and you have a -2 pixel offsetY then item will be placed at: ((y*2) + -2)
	--It should not be more than 16 or less than -16 else it will look like it's on a different tile
PositionoffsetX = (num), 
PositionoffsetY = (num),

	--When your object is being placed in the house, it will take this info and place the object in that general area
spawnLocationInfo = (string), --The follwing are the strings it could be:
	--"Spawn Underneath Wall" -Object will spawn on or directly under a wall
	--"Corner Floor Tiles"	  -Object will spawn in the corners of houses/rooms
	--"Middle of Floor Tiles" -Object will spawn in the middle of the room at least 1 tile away from all walls/borders
	--'Bottom Floor Tiles'    -Object will always spawn at the bottom of the house

	--Spawn Underneath Wall will instinctively make the object spawn higher against the wall so that the object looks like it's against the wall
	--However if you don't want this to occure set this value to true
doNotrenderHigherOnWall = (bool),

	--Places the object heigher on the wall
placeMuchHeigherOnWalls = (bool),

	--Gives the object a name which may displayed, mandatory for stealable items. Can not be longer than 10 characters
name = (string)
	--This indicates wheather the object can be stolen, which makes it dissapear from map once stolen
stealable = (bool)
	--If the object can be stolen this indicates it's worth, like amount of money willl be given to player for steal
objectsWorth = (int)

	--If the object can be destroyed, set to true if it can't
canNotBeDestroyed = true,

	--wheather or not entities can see past this object
opaque = (bool),

	--The type can change the behaviour of the object and how it spawns
type = (string),
	--"Window"   -Object will behave as a window(only spawn on back wall)

	-- If not specified object is assumed to be solid. This specifys wheather the object can collide with the player. If true then the player can pass through it.
notSolid = (bool),

	--This specifys the quads/tiles that are collidable and solid on this object. However this parameter is optional if not specifiede the whole object is collidabable.
tilesThatObjectCanCollideWith = {{y=(num),x=(num)}, {y=(num),x=(num)}, },

	--If the player is on this object it makes the player render underneath it instead of on top of it
renderPlayerUnderObject = (bool),

	--If you want this object to have other objects spawning on top of it then set this value to true
objectCanBePlacedOnThisObject = true,

	--This specifys the quads/tiles that objects can be placed on this object. The list can go on.
tilesThatObjectsCanCollideWith = {{y=(num),x=(num)}, {y=(num),x=(num)}, },

	--This specifys objects that can be placed on the tiles above (the object is chosen at random from this list)
objectsToPlace = { 
{objectInfo = (object definition), offsetX = (num), offsetY = (num)}, 	--These offsets are added positional offsets that go on the object
{objectInfo = (object definition), offsetX = (num), offsetY = (num)},
},

	--This specifys the chance for the object to be placed on a tile. 1 means there is an absolout chance the object will be placed.
chanceForObjectToPlace = (num),

	--This specifys what will happen when an object spawns. With the function letting the user personalize what will happen
onSpawnInformation = {type = (string), OnSpawn = function(object)}
	--List of accepted strings:
	--"multiple objects spawn" - This will run the OnSpawn function and expect it to return multiple objects, all of which will spawn but not check each other for collision.
	--Example: OnSpawn = function(object)
		local objectsThatCanSpawn = {}

		table.insert(objectsThatCanSpawn, {
		objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Left Wooden chair'], 
		x = position.x + 1, 
		y = position.y - 1,
		offsetX = -14,
		offsetY = 00,})

		return objectsThatCanSpawn
	end



Example
	['Table wooden 3x4'] = {
		--appearance
		quadX = 1,
		quadY = 11,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -8,
		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Middle of Floor Tiles",

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=1,x=2}, {y=1,x=3}, {y=2,x=2}, {y=2,x=3}},
		objectsToPlace = { 
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Oranges'], offsetX = 0, offsetY = -15},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Apples'], offsetX = 0, offsetY = -15},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Eggplants'], offsetX = 0, offsetY = -15},
		},
		chanceForObjectToPlace = 2,

		onSpawnInformation = {type = "multiple objects spawn",
		OnSpawn = function(object)
			local objectsThatCanSpawn = {}

			for y = 1, object.tileHeight do
				for x = 1, object.tileWidth do

					if y == object.tileHeight then
						goto skip
					end

					if y == 1 then --spawns object to the top of tiles (since we are on the top most edge)
						if(y == 1 and x == 1) or (y == 1 and x == object.tileWidth) then	else
							local position = object:returnSpecifQuadPosition(x, y)
							table.insert(objectsThatCanSpawn, {
							objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Forward Wooden chair'], 
							x = position.x, 
							y = position.y - 2,
							offsetX = 0,
							offsetY = 0,})
						end
					end

					if x == 1 then --Spawns object to the left of tiles (since we are on the left most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Right Wooden chair'], 
						x = position.x - 1, 
						y = position.y - 1,
						offsetX = 10,
						offsetY = 0,})
					end

					if x == object.tileWidth then --soawns object to the right of tiles (since we are on the right most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Left Wooden chair'], 
						x = position.x + 1, 
						y = position.y - 1,
						offsetX = -14,
						offsetY = 00,})
					end
					::skip::
				end
			end 

		return objectsThatCanSpawn
		end}
	},

	package
	Guitar
	bonzai
	chimney
	fire
]]

PLACEABLE_BIG_GAME_OBJECTS = {
	['TV_Old_Off'] = {
		--appearance
		quadX = 8,
		quadY = 198,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['TV_Modern'] = {
		--appearance
		quadX = 10,
		quadY = 165,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		spawnLocationInfo = "Spawn Underneath Wall",
		stealable = true,
		objectsWorth = 50,
		name = 'TV Modern'
	},
	['Terrarium'] = {
		--appearance
		quadX = 1,
		quadY = 151,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Corner Floor Tiles", 
		--doNotrenderHigherOnWall = true,
		stealable = true,
		objectsWorth = 50,
		name = 'Terrarium'
	},
	['Computer'] = {
		--appearance
		quadX = 9,
		quadY = 50,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 20,
		name = 'Computer'
	},
}

GAME_OBJECTS_TOYS = {
	['Toy_House'] = {
		--appearance
		quadX = 10,
		quadY = 169,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,

		--doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall"
	},

	['Robot_Toy'] = {
		--appearance
		quadX = 5,
		quadY = 185,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},
	['Blue_Girl'] = {
		--appearance
		quadX = 8,
		quadY = 180,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0,
		PositionoffsetY = 0,
		notSolid = true,
	},
	['Yellow_Girl'] = {
		--appearance
		quadX = 8,
		quadY = 182,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},

	['Blue_Haired_Plush'] = {
		--appearance
		quadX = 3,
		quadY = 178,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

	['Train'] = {
		--appearance
		quadX = 3,
		quadY = 180,
		tileWidth = 4,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		spawnLocationInfo = 'Bottom Floor Tiles',
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2}, {y=2,x=3}, {y=2,x=4}, },
	},
	['Train_Track'] = {
		--appearance
		quadX = 14,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

}

PLACABLE_GAME_OBJECT_DEFS = {
	['Oranges'] = {
		--appearance
		quadX = 43,
		quadY = 25,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 4,
		name = 'Oranges'
	},
	['Apples'] = {
		--appearance
		quadX = 44,
		quadY = 25,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 4,
		name = 'Apples'
	},
	['Eggplants'] = {
		--appearance
		quadX = 45,
		quadY = 25,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 4,
		name = 'Eggplants'
	},
	['Silver_Globe'] = {
		--appearance
		quadX = 16,
		quadY = 37,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 10,
		name = 'Silver Globe'
	},
	['Golden_Globe'] = {
		--appearance
		quadX = 16,
		quadY = 35,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 15,
		name = 'Golden Globe'
	},
	['Desk_Plant'] = {
		--appearance
		quadX = 13,
		quadY = 29,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 5,
		name = 'Desk Plant'
	},

	['Golden_Candle'] = {
		--appearance
		quadX = 5,
		quadY = 32,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 5,
		name = 'Golden Candle'
	},
	['Blue_Table_Lamp'] = {
		--appearance
		quadX = 4,
		quadY = 32,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 6,
		name = 'Blue Lamp'
	},
	['White_Table_Lamp'] = {
		--appearance
		quadX = 3,
		quadY = 32,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 6,
		name = 'White Lamp'
	},
	['Table_Mirror'] = {
		--appearance
		quadX = 1,
		quadY = 34,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 9,
		name = 'Table Mirror'
	},

	['Phone_Black'] = {
		--appearance
		quadX = 12,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 12,
		name = 'Phone Black'
	},
	['Phone_Blue'] = {
		--appearance
		quadX = 13,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 12,
		name = 'Phone Blue'
	},
	['Phone_Red'] = {
		--appearance
		quadX = 12,
		quadY = 211,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 12,
		name = 'Phone Red'
	},

	['steak plate'] = {
		--appearance
		quadX = 12,
		quadY = 14,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 1,
		name = 'cold steak'
	},
	['sphaghetti'] = {
		--appearance
		quadX = 13,
		quadY = 15,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 2,
		name = 'sphaghetti'
	},
	['pizza'] = {
		--appearance
		quadX = 12,
		quadY = 15,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 4,
		name = 'hot pizza'
	},
	['radio'] = {
		--appearance
		quadX = 5,
		quadY = 103,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		notSolid = true,
		stealable = true,
		objectsWorth = 14,
		name = 'Radio'
	},

	['bonzai_tree brown'] = {
		--appearance
		quadX = 8,
		quadY = 99,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',	
		stealable = true,
		objectsWorth = 10,
		name = 'oak bonzai',
		tilesThatObjectCanCollideWith = {{y=2,x=1}},
	},
	['bonzai_tree white'] = {
		--appearance
		quadX = 9,
		quadY = 99,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',
		stealable = true,
		objectsWorth = 10,
		name = 'birch bonzai',
		tilesThatObjectCanCollideWith = {{y=2,x=1}},
	},
}

LAMP = {
	['Blue_Lamp'] = {
		--appearance
		quadX = 2,
		quadY = 31,
		tileWidth = 1,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['White_Lamp'] = {
		--appearance
		quadX = 1,
		quadY = 31,
		tileWidth = 1,
		tileHeight = 3,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		spawnLocationInfo = "Corner Floor Tiles",
		notSolid = true,
		--tilesThatObjectCanCollideWith = {{y=3,x=1}, },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 4,
		name = 'White lampxL'
	},	

	['Fire_Place'] = {
		--appearance
		quadX = 15,
		quadY = 58,
		tileWidth = 2,
		tileHeight = 3,
		opaque = true,

		PositionoffsetX = 0, 
		PositionoffsetY = 4,
		spawnLocationInfo = "Spawn Underneath Wall",
		canNotBeDestroyed = true,
	},
}

ESCAPE_GAME_OBJECT_DEFS = {
	['Door'] = {
		--appearance
		quadX = 8,
		quadY = 9,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Door_grey'] = {
		--appearance
		quadX = 17,
		quadY = 219,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Door_red'] = {
		--appearance
		quadX = 17,
		quadY = 219,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Door_Barrackaded'] = {
		--appearance
		quadX = 8,
		quadY = 215,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Door Double Glass'] = {
		--appearance
		quadX = 3,
		quadY = 44,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		notSolid = true,
	},
	['Window_Plain'] = {
		--appearance
		quadX = 20,
		quadY = 13,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		canNotBeDestroyed = true,
	},

	['Window_Red_Curtains_Closed'] = {
		--appearance
		quadX = 8,
		quadY = 228,
		tileWidth = 3,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Window_Blue_Curtains_Closed'] = {
		--appearance
		quadX = 11,
		quadY = 228,
		tileWidth = 3,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		notSolid = true,
		canNotBeDestroyed = true,
	},
	['Window_Brown_Curtains_Closed'] = {
		--appearance
		quadX = 14,
		quadY = 228,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Window_Red_Curtains_Open'] = {
		--appearance
		quadX = 4,
		quadY = 229,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		notSolid = true,
		canNotBeDestroyed = true,
	},
	['Window_Blue_Curtains_Open'] = {
		--appearance
		quadX = 1,
		quadY = 231,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		notSolid = true,
		canNotBeDestroyed = true,
	},
	['Window_Brown_Curtains_Open'] = {
		--appearance
		quadX = 1,
		quadY = 229,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		notSolid = true,
		canNotBeDestroyed = true,
	},
}

GAME_OBJECTS_SPOOKY = {
	['Cofin_Empty'] = {
		--appearance
		quadX = 1,
		quadY = 226,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Cofin_Standing'] = {
		--appearance
		quadX = 10,
		quadY = 194,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Cofin_Full'] = {
		--appearance
		quadX = 3,
		quadY = 226,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Pentagram'] = {
		--appearance
		quadX = 1,
		quadY = 214,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Pentagram_Lights'] = {
		--appearance
		quadX = 3,
		quadY = 212,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Sleeping_Cat'] = {
		--appearance
		quadX = 3,
		quadY = 211,
		tileWidth = 3,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Bone'] = {
		--appearance
		quadX = 1,
		quadY = 212,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Blood'] = {
		--appearance
		quadX = 10,
		quadY = 217,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Wall_Mounted_Cross'] = {
		--appearance
		quadX = 14,
		quadY = 217,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Candles_Lit'] = {
		--appearance
		quadX = 6,
		quadY = 216,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Candles_Unlit'] = {
		--appearance
		quadX = 7,
		quadY = 218,
		tileWidth = 2,
		tileHeight = 1,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Ghost_Mask'] = {
		--appearance
		quadX = 16,
		quadY = 211,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Shrek_Mask'] = {
		--appearance
		quadX = 14,
		quadY = 211,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Bear_Mask'] = {
		--appearance
		quadX = 14,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Silver_Bear_Mask'] = {
		--appearance
		quadX = 15,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Saw_Mask'] = {
		--appearance
		quadX = 16,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Wizard_Hat'] = {
		--appearance
		quadX = 8,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

	['Magic_Book'] = {
		--appearance
		quadX = 14,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

	['Spider'] = {
		--appearance
		quadX = 3,
		quadY = 191,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

	['Pumkin1'] = {
		--appearance
		quadX = 6,
		quadY = 190,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Pumkin2'] = {
		--appearance
		quadX = 7,
		quadY = 190,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},
	['Pumkin3'] = {
		--appearance
		quadX = 8,
		quadY = 190,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
	},

}

SOLID_GAME_OBJECT_DESKS = {
	--desks
	['Average Desk'] = {
		--appearance
		quadX = 32,
		quadY = 26,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Writting Desk Fancy 2x2'] = {
		--appearance
		quadX = 21,
		quadY = 26,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",

	},
	['School Desk regular'] = {
		--appearance
		quadX = 24,
		quadY = 37,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

	['Modern Desk Brown Broad'] = {
		--appearance
		quadX = 1,
		quadY = 184,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Modern Desk White Broad'] = {
		--appearance
		quadX = 1,
		quadY = 186,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		spawnLocationInfo = "Spawn Underneath Wall",
		opaque = true,

		--tilesThatObjectCanCollideWith =  {{y=1,x=1}, {y=1,x=2}},

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=2,x=1}, {y=2,x=2}},
		objectsToPlace = { 
		--{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Oranges'], offsetX = 2, offsetY = -24},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['White_Table_Lamp'], offsetX = 2, offsetY = -23},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Silver_Globe'], offsetX = 1, offsetY = -22},
		--{objectInfo = PLACABLE_GAME_OBJECT_DEFS['radio'], offsetX = 0, offsetY = -20},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Table_Mirror'], offsetX = 1, offsetY = -22},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Phone_Black'], offsetX = 1, offsetY = -20},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Golden_Globe'], offsetX = 1, offsetY = -22},
		},
		chanceForObjectToPlace = 3,
		canNotBeDestroyed = true,
	},

	['Modern Desk Brown single'] = {
		--appearance
		quadX = 8,
		quadY = 161,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Modern Desk White single'] = {
		--appearance
		quadX = 9,
		quadY = 161,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		spawnLocationInfo = "Spawn Underneath Wall",
		opaque = true,

		--tilesThatObjectCanCollideWith =  {{y=1,x=1},},

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=2,x=1}},
		objectsToPlace = { 
		--{objectInfo = GAME_OBJECTS_TOYS['Robot_Toy'], offsetX = 0, offsetY = -29},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Golden_Globe'], offsetX = 2, offsetY = -26},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Silver_Globe'], offsetX = 2, offsetY = -26},
		--{objectInfo = PLACABLE_GAME_OBJECT_DEFS['radio'], offsetX = 0, offsetY = -20},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['White_Table_Lamp'], offsetX = 2, offsetY = -27},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Table_Mirror'], offsetX = 2, offsetY = -26},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Phone_Black'], offsetX = 2, offsetY = -26},


		},
		chanceForObjectToPlace = 3,
		canNotBeDestroyed = true,
	},

}

SOLID_GAME_OBJECTS_BEDS = {
		--Beds
	['Wooden Bed'] = {
		--appearance
		quadX = 29,
		quadY = 30,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall"
	},
	['Plain_Bed'] = {
		--appearance
		quadX = 6,
		quadY = 211,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -6,

		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall",
		tilesThatObjectCanCollideWith = {{y=1,x=1}, {y=1,x=2}, {y=2,x=1}, {y=2,x=2},},
		stealable = true,
		objectsWorth = 8,
		name = 'Plain Bed'
	},
	['Holloween_Bed'] = {
		--appearance
		quadX = 1,
		quadY = 223,
		tileWidth = 2,
		tileHeight = 4,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall"
	},

	['Green_Bed'] = {
		--appearance
		quadX = 9,
		quadY = 172,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -6,

		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall",
		tilesThatObjectCanCollideWith = {{y=1,x=1}, {y=1,x=2}, {y=2,x=1}, {y=2,x=2},},
	},
	['Blue_Bed'] = {
		--appearance
		quadX = 11,
		quadY = 172,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Spawn Underneath Wall"
	},

}

GAME_OBJECTS_VAULTS = {
	['Vault_Locked'] = {
		--appearance
		quadX = 1,
		quadY = 247,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 8,
		name = 'Locked Vault'
	},
	['Vault_Empty'] = {
		--appearance
		quadX = 2,
		quadY = 247,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
	['Vault_Gold'] = {
		--appearance
		quadX = 3,
		quadY = 247,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
	['Vault_Emerals'] = {
		--appearance
		quadX = 4,
		quadY = 247,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
}

GAME_OBJECTS_MIRRORS = {
	['Mirror_Wood'] = {
		--appearance
		quadX = 1,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 5,
		name = 'Wooden Mirror'
	},
	['Mirror_Silver'] = {
		--appearance
		quadX = 4,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 10,
		name = 'Silver Mirror'
	},
	['Mirror_Gold'] = {
		--appearance
		quadX = 3,
		quadY = 207,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 20,
		name = 'Gold Mirror'
	},

	['Mirror_Gold_Broken'] = {
		--appearance
		quadX = 3,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
	['Mirror_Wood_Broken'] = {
		--appearance
		quadX = 1,
		quadY = 209,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},

	['Mirror_Haunted'] = {
		--appearance
		quadX = 13,
		quadY = 215,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
}

SOLID_GAME_OBJECTS_SHELVES = {
	--Shelves
	['Book Shelf1'] = {
		--appearance
		quadX = 22,
		quadY = 14,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,

		spawnLocationInfo = "Spawn Underneath Wall",
	},
	['Book Shelf2'] = {
		--appearance
		quadX = 23,
		quadY = 19,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		spawnLocationInfo = "Spawn Underneath Wall",
	},
	['Book Shelf3'] = {
		--appearance
		quadX = 17,
		quadY = 39,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,

		spawnLocationInfo = "Spawn Underneath Wall",
		stealable = true,
		objectsWorth = 16,
		name = 'Book Shelf'
	},
}

SOLID_GAME_OBJECTS_TABLES = {
		--Tables
	['Table wooden 3x4'] = {
		--appearance
		quadX = 1,
		quadY = 11,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -8,
		doNotrenderHigherOnWall = true,
		spawnLocationInfo = "Middle of Floor Tiles",

		tilesThatObjectCanCollideWith =  {{y=1,x=2}, {y=1,x=3}, {y=2,x=2}, {y=2,x=3}},

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=1,x=2}, {y=1,x=3}, {y=2,x=2}, {y=2,x=3}},
		objectsToPlace = { 
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Oranges'], offsetX = 0, offsetY = -15},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Apples'], offsetX = 0, offsetY = -15},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Eggplants'], offsetX = 0, offsetY = -15},
		},
		chanceForObjectToPlace = 2,
		canNotBeDestroyed = true,

		onSpawnInformation = {type = "multiple objects spawn",
		OnSpawn = function(object)
			local objectsThatCanSpawn = {}

			for y = 1, object.tileHeight do
				for x = 1, object.tileWidth do

					if y == object.tileHeight then
						goto skip
					end

					if y == 1 then --spawns object to the top of tiles (since we are on the top most edge)
						if(y == 1 and x == 1) or (y == 1 and x == object.tileWidth) then	else
							local position = object:returnSpecifQuadPosition(x, y)
							table.insert(objectsThatCanSpawn, {
							objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Forward Wooden chair'], 
							x = position.x, 
							y = position.y - 2,
							offsetX = 0,
							offsetY = 0,})
						end
					end

					if x == 1 then --Spawns object to the left of tiles (since we are on the left most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Right Wooden chair'], 
						x = position.x - 1, 
						y = position.y - 1,
						offsetX = 10,
						offsetY = 0,})
					end

					if x == object.tileWidth then --soawns object to the right of tiles (since we are on the right most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Left Wooden chair'], 
						x = position.x + 1, 
						y = position.y - 1,
						offsetX = -14,
						offsetY = 00,})
					end
					::skip::
				end
			end 

		return objectsThatCanSpawn
		end}
	},
	['Table wooden 2x4'] = {
		--appearance
		quadX = 24,
		quadY = 13,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
		onSpawnInformation = {type = "multiple objects spawn",
		OnSpawn = function(object)
		
		return objectsThatCanSpawn
		end}
	},
	['Table Fancy 3x4'] = {
		--appearance
		quadX = 8,
		quadY = 28,
		tileWidth = 3,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},

	['Table Dark_Wood 3x4'] = {
		--appearance
		quadX = 1,
		quadY = 201,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",

		tilesThatObjectCanCollideWith =  {{y=1,x=2}, {y=1,x=3}, {y=2,x=2}, {y=2,x=3}},

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=1,x=2}, {y=1,x=3}, {y=2,x=2}, {y=2,x=3}},
		objectsToPlace = { 
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['steak plate'], offsetX = 0, offsetY = 0},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['sphaghetti'], offsetX = 0, offsetY = 0},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['pizza'], offsetX = 0, offsetY = 0},
		},
		chanceForObjectToPlace = 3,

		onSpawnInformation = {type = "multiple objects spawn",
		OnSpawn = function(object)
			local objectsThatCanSpawn = {}

			for y = 1, object.tileHeight do
				for x = 1, object.tileWidth do

					if y == object.tileHeight then
						goto skip
					end

					if y == 1 then --spawns object to the top of tiles (since we are on the top most edge)
						if(y == 1 and x == 1) or (y == 1 and x == object.tileWidth) then	else
							local position = object:returnSpecifQuadPosition(x, y)
							table.insert(objectsThatCanSpawn, {
							objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Forward Wooden chair'], 
							x = position.x, 
							y = position.y - 2,
							offsetX = 0,
							offsetY = 0,})
						end
					end

					if x == 1 then --Spawns object to the left of tiles (since we are on the left most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Right Wooden chair'], 
						x = position.x - 1, 
						y = position.y - 1,
						offsetX = 10,
						offsetY = 0,})
					end

					if x == object.tileWidth then --soawns object to the right of tiles (since we are on the right most edge)
						local position = object:returnSpecifQuadPosition(x, y)
						table.insert(objectsThatCanSpawn, {
						objectInfo = SOLID_GAME_OBJECTS_CHAIRS['Left Wooden chair'], 
						x = position.x + 1, 
						y = position.y - 1,
						offsetX = -14,
						offsetY = 00,})
					end
					::skip::
				end
			end 

		return objectsThatCanSpawn
		end}
	},
	['Table White_Wood 3x4'] = {
		--appearance
		quadX = 6,
		quadY = 201,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},
	['Table Yellow_Wood 3x4'] = {
		--appearance
		quadX = 1,
		quadY = 204,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},
	['Table Orange_Wood 3x4'] = {
		--appearance
		quadX = 6,
		quadY = 204,
		tileWidth = 4,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},



	['Table White_Wood 2x3'] = {
		--appearance
		quadX = 11,
		quadY = 201,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},
	['Table Yellow_Wood 2x3'] = {
		--appearance
		quadX = 14,
		quadY = 201,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},
	['Table Orange_Wood 2x3'] = {
		--appearance
		quadX = 11,
		quadY = 203,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},
	['Table Dark_Wood 2x3'] = {
		--appearance
		quadX = 14,
		quadY = 203,
		tileWidth = 3,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Middle of Floor Tiles",
	},

}

SOLID_GAME_OBJECTS_CANVAS = {
		--Canvases
	['Fire place canvas'] = {
		--appearance
		quadX = 31,
		quadY = 81,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3,x=2},},
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 12,
		name = 'Fire painting'
	},
	['Evil canvas1'] = {
		--appearance
		quadX = 27,
		quadY = 84,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3,x=2},},
		renderPlayerUnderObject = true
	},
	['Evil canvas2'] = {
		--appearance
		quadX = 29,
		quadY = 84,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3,x=2},},
		renderPlayerUnderObject = true
	},
}

SOLID_GAME_OBJECTS_CHAIRS = {
	--Chairs
	['Stool'] = {
		--appearance
		quadX = 23,
		quadY = 13,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},
	['Right Wooden chair'] = {
		--appearance
		quadX = 23,
		quadY = 21,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},
	['Left Wooden chair'] = {
		--appearance
		quadX = 24,
		quadY = 21,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},
	['Forward Wooden chair'] = {
		--appearance
		quadX = 19,
		quadY = 21,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		notSolid = true,
	},

}



SOLID_GAME_OBJECTS_INSTRUMENTS = {
	--Instruments
	['Wooden Harp'] = {
		--appearance
		quadX = 30,
		quadY = 64,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2},},
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 25,
		name = 'Wooden Harp'

	},
	['Golden Harp'] = {
		--appearance
		quadX = 30,
		quadY = 66,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2},},
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 75,
		name = 'Golden Harp'
	},
	['Guitar'] = {
		--appearance
		quadX = 29,
		quadY = 63,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		tilesThatObjectCanCollideWith = {{y=2,x=1}, },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 12,
		name = 'Guitar'
	},

}

SOLID_GAME_OBJECTS_MISC = {
	--Random objects
	['Package'] = {
		--appearance
		quadX = 13,
		quadY = 12,
		tileWidth = 1,
		tileHeight = 1,

		PositionoffsetX = 0, 
		PositionoffsetY = -4,
		stealable = true,
		objectsWorth = 4,
		name = 'Package'
	},
	['Plant tree 2x3'] = {
		--appearance
		quadX = 27,
		quadY = 28,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = 0, 
		PositionoffsetY = 4,
		spawnLocationInfo = "Corner Floor Tiles",
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3, x=2}, },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 9,
		name = 'Indoor Tree'
	},
	['Plant palm 2x3'] = {
		--appearance
		quadX = 15,
		quadY = 29,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = 0, 
		PositionoffsetY = 4,
		spawnLocationInfo = "Corner Floor Tiles",
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3, x=2} },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 15,
		name = 'Palm Tree'
	},
	['Pot1'] = {
		--appearance
		quadX = 27,
		quadY = 98,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = 0, 
		PositionoffsetY = 0,
		spawnLocationInfo = 'Bottom Floor Tiles'
	},
	['Pot2'] = {
		--appearance
		quadX = 28,
		quadY = 98,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
	['Pot3'] = {
		--appearance
		quadX = 29,
		quadY = 98,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},

}

BATHROOM_ITEMS = {
	['washing machine'] = {
		--appearance
		quadX = 13,
		quadY = 103,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = -1
	},
}

WALL_MOUNTED_GAME_OBJECTS = {
	['Nemo Painting'] = {
		--appearance
		quadX = 3,
		quadY = 151,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 10,
		name = 'Nemo Print'
	},
	['Shark Head'] = {
		--appearance
		quadX = 7,
		quadY = 151,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 25,
		name = 'Shark Head'
	},
	['gold mounted fish'] = {
		--appearance
		quadX = 7,
		quadY = 135,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 40,
		name = 'Golden Fish'
	},
	['empty mounted fish stand'] = {
		--appearance
		quadX = 5,
		quadY = 135,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 5,
		name = 'Fish Stand'
	},
	['sunset painting'] = {
		--appearance
		quadX = 5,
		quadY = 133,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
		stealable = true,
		objectsWorth = 40,
		name = 'Sunset Painting'
	},
	['yin-yang painting'] = {
		--appearance
		quadX = 1,
		quadY = 124,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
	['shark painting'] = {
		--appearance
		quadX = 3,
		quadY = 124,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Spawn Underneath Wall",
		type = "Window",
	},
}

PLACABLE_FISHING_ITEMS = {
	['fish_bait_blue'] = {
		--appearance
		quadX = 4,
		quadY = 127,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		stealable = true,
		objectsWorth = 4,
		name = 'Bad bait'
	},
	['fish_bait_red'] = {
		--appearance
		quadX = 7,
		quadY = 127,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		stealable = true,
		objectsWorth = 8,
		name = 'Good bait'
	},
	['container of Gold scales'] = {
		--appearance
		quadX = 13,
		quadY = 133,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		stealable = true,
		objectsWorth = 18,
		name = 'Golden Scales'
	},
	['container of fish organs'] = {
		--appearance
		quadX = 14,
		quadY = 133,
		tileWidth = 1,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		stealable = true,
		objectsWorth = 2,
		name = 'Fish Organs'
	},
}

FISHING_ITEMS = {
	['fish cleaning bench'] = {
		--appearance
		quadX = 3,
		quadY = 139,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		spawnLocationInfo = "Spawn Underneath Wall",
	},


	['single rod stand'] = {
		--appearance
		quadX = 5,
		quadY = 139,
		tileWidth = 1,
		tileHeight = 3,

		PositionoffsetX = 0, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Corner Floor Tiles",
		tilesThatObjectCanCollideWith = {{y=3,x=1}, },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 8,
		name = 'Fishing Rods'
	},
	['multiple rod stand'] = {
		--appearance
		quadX = 10,
		quadY = 141,
		tileWidth = 3,
		tileHeight = 3,

		PositionoffsetX = 0, 
		PositionoffsetY = -1,
		spawnLocationInfo = "Corner Floor Tiles",
		tilesThatObjectCanCollideWith = {{y=3,x=1}, {y=3,x=2}, {y=3,x=3} },
		renderPlayerUnderObject = true,
		stealable = true,
		objectsWorth = 18,
		name = '3 fishing rods',
	},


	['lots of containers'] = {
		--appearance
		quadX = 7,
		quadY = 132,
		tileWidth = 2,
		tileHeight = 3,

		PositionoffsetX = -2, 
		PositionoffsetY = 6,
		spawnLocationInfo = "Corner Floor Tiles", 
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2}, {y=3,x=1}, {y=3,x=2}},
		--doNotrenderHigherOnWall = true,
		stealable = true,
		objectsWorth = 10,
		name = 'Containers'
	},

	['yellow_cooler'] = {
		--appearance
		quadX = 1,
		quadY = 132,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2}, },
		renderPlayerUnderObject = true,
	},
	['blue_cooler'] = {
		--appearance
		quadX = 1,
		quadY = 130,
		tileWidth = 2,
		tileHeight = 2,

		PositionoffsetX = -2, 
		PositionoffsetY = -1,
		spawnLocationInfo = 'Bottom Floor Tiles',
		tilesThatObjectCanCollideWith = {{y=2,x=1}, {y=2,x=2}, },
		renderPlayerUnderObject = true,
	},
	['metal table'] = {
		--appearance
		quadX = 13,
		quadY = 135,
		tileWidth = 3,
		tileHeight = 2,
		tilesThatObjectCanCollideWith = {{y=1,x=2},},
		PositionoffsetX = -2, 
		PositionoffsetY = -1,

		spawnLocationInfo = "Middle of Floor Tiles",

		objectCanBePlacedOnThisObject = true,
		tilesThatObjectsCanBePlacedOn = {{y=1,x=2}},
		objectsToPlace = { 
		{objectInfo = PLACABLE_FISHING_ITEMS['fish_bait_blue'], offsetX = 0, offsetY = -12},
		{objectInfo = PLACABLE_FISHING_ITEMS['container of fish organs'], offsetX = 0, offsetY = -14},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['steak plate'], offsetX = 0, offsetY = 0},
		{objectInfo = PLACABLE_FISHING_ITEMS['fish_bait_red'], offsetX = 0, offsetY = -12},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['Oranges'], offsetX = 0, offsetY = -12},
		{objectInfo = PLACABLE_FISHING_ITEMS['container of Gold scales'], offsetX = 0, offsetY = -14},
		{objectInfo = PLACABLE_GAME_OBJECT_DEFS['radio'], offsetX = 0, offsetY = -4},
		{objectInfo = PLACEABLE_BIG_GAME_OBJECTS['Computer'], offsetX = -8, offsetY = -15},
		},
		chanceForObjectToPlace = 4,
		canNotBeDestroyed = true,
	},
}

