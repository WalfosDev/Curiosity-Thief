--[[
*General Information*---------------------------------------------------------------------
This contains the definitions that define how an actuall house itself will look. But before we delve into that I must
first give some background information on what a house is.

This game is completely tile based, and a house is the area that player plays in. I wanted the game to be able to make multiple different types
of houses so is composed the game such that it can take a list of definitions and convert that into a house.

Inside the houses you may also find furniture, furniture is defined in object_defs and made using solid object maker.
However we want to be able to pick and choose what furniture can be added into any given house type,so the definitions enable that.
There are 6 general furniture types, for each you may define the amount of furniture to spawn for this type and what furniture can spawn
for this furniture type. Why it isn't grouped into one big table of furnitures is because it allows you to better personalize the houses.

Each furniture type is also made in an order, means teach furniture type has a different spawning priority:
(1)beds          --Spawns first
(2)wallMounted
(3)windows
(4)tables
(5)decorative	
(6)hobbyObjects	 --Spawn last
(Furniture in a furniture type does not have to adhere to it's type's name however it is advised)




*List of all definitons and how to use them*---------------------------------------------------------------------

	--Describes this objects type
type = "shed",

	--This is the ammount of ai that may spawn in this house
maxNumberOfai = (num),
minNumberOfai = (num),

	--The type of door this room has (has not been implimented)
Door = ESCAPE_GAME_OBJECT_DEFS['Door Double Glass'],

	--This determines the tile width and tile height of the house, with the value being between min and max
WidthMin = 10,
WidthMax = 15,
HeightMin = 10,
HeightMax =12,

	--this determines the maximum amount of time the player can be in the house before the police spawn
maxTimeBeforePoliceSpawn = 
	--This determines the minimum ammount of time the player has until the police spawn
minTimeBeforePoliceSpawn = 

	--This determines the floor and wall texture for the house. The floor and wall textures are together in a table, a table will be randomly chosen
	--to be a floor and wall texture. There can be as many tables as you would like to have.
houseTileSets = {
    {walls = (string name of a tileset texture), floors = (string name of a tileset texture)}, 
    {walls = (string name of a tileset texture), floors = (string name of a tileset texture)},
},
	^^^Note: Only give the string name of the textures and it should be found in gTextures^^^

	--Determines the ammount of each item of furniture there is, with it ranging between max and min
bedsAmmount = {max = (num), min = (num)},
windowsAmmount = {max = (num), min = (num)},
tablesAmmount = {max = (num), min = (num)},
wallMountedAmmount = {max = (num), min = (num)},
decorativeAmmount = {max = (num), min = (num)},
hobbyObjectsAmmount = {max = (num), min = (num)},

	--Determines the furnitures for each furniture type, with these furnitures being randmoly chosen
bedObjects = {
(objectInfo),
(objectInfo)
},

windowObjects = {
(objectInfo),
(objectInfo),
},

tableObjects = {
(objectInfo),
(objectInfo),
},

wallMountedObjects = {
(objectInfo),
(objectInfo),
},

decorativeObjects = {
(objectInfo),
(objectInfo),
},

hobbyObjects = {
(objectInfo),
(objectInfo),
},

Optional parameters:
	--Set to true if you don't want rooms to spawn
noRooms = (bool)




*List of all definitons*---------------------------------------------------------------------
type = "shed",

Door = ESCAPE_GAME_OBJECT_DEFS['Door Double Glass'],

WidthMin = 10,
WidthMax = 15,
HeightMin = 10,
HeightMax =12,

maxTimeBeforePoliceSpawn = 60,
minTimeBeforePoliceSpawn = 5,

houseTileSets = {
    {walls = (string name of a tileset texture), floors = (string name of a tileset texture)},
    {walls = (string name of a tileset texture), floors = (string name of a tileset texture)},
},


bedsAmmount = {max = (num), min = (num)},
windowsAmmount = {max = (num), min = (num)},
tablesAmmount = {max = (num), min = (num)},
wallMountedAmmount = {max = (num), min = (num)},
decorativeAmmount = {max = (num), min = (num)},
hobbyObjectsAmmount = {max = (num), min = (num)},


bedObjects = {
(objectInfo),
},

windowObjects = {
(objectInfo),
},

tableObjects = {
(objectInfo),
},

wallMountedObjects = {
(objectInfo),
},

decorativeObjects = {
(objectInfo),
},

hobbyObjects = {
(objectInfo),
},

noRooms = (bool)

]]

HOUSE_DEFS = {
	Shed = {

		type = "shed",

		maxNumberOfai = 4,
		minNumberOfai = 2,

		Door = ESCAPE_GAME_OBJECT_DEFS['Door Double Glass'],

		noRooms = true,

		WidthMin = 65,
		WidthMax = 90,

		HeightMin = 10,
		HeightMax =12,

		maxTimeBeforePoliceSpawn = 40,
		minTimeBeforePoliceSpawn = 9,

		houseTileSets = {
		    {walls = "log_Cabin_House3", floors = "log_Cabin_House3"},
		},

		bedsAmmount = {max = 2, min = 5},
		windowsAmmount = {max = 20, min = 10},
		tablesAmmount = {max = 8, min = 4},
		wallMountedAmmount = {max = 10, min = 3},
		decorativeAmmount = {max = 10, min = 3},
		hobbyObjectsAmmount = {max = 6, min = 0},

		bedObjects = {--SOLID_GAME_OBJECTS_BEDS['Wooden Bed'],
		SOLID_GAME_OBJECTS_BEDS['Plain_Bed'],
		SOLID_GAME_OBJECTS_BEDS['Green_Bed']},

		windowObjects = {ESCAPE_GAME_OBJECT_DEFS['Window_Red_Curtains_Open'],
		ESCAPE_GAME_OBJECT_DEFS['Window_Red_Curtains_Open'],
		LAMP['Fire_Place'], --16% chanvce of spawning
		ESCAPE_GAME_OBJECT_DEFS['Window_Red_Curtains_Open'],
		ESCAPE_GAME_OBJECT_DEFS['Window_Red_Curtains_Open'],
		ESCAPE_GAME_OBJECT_DEFS['Window_Red_Curtains_Open'],
		},

		--FISHING_ITEMS

		tableObjects = {
		--SOLID_GAME_OBJECTS_TABLES['Table wooden 3x4'],
		FISHING_ITEMS['metal table'],
		FISHING_ITEMS['fish cleaning bench'],
		FISHING_ITEMS['metal table'],
		FISHING_ITEMS['metal table'],
		},

		wallMountedObjects = {
			--LAMP['Fire_Place'],
			WALL_MOUNTED_GAME_OBJECTS['Nemo Painting'],
			WALL_MOUNTED_GAME_OBJECTS['Shark Head'],
			WALL_MOUNTED_GAME_OBJECTS['gold mounted fish'],
			WALL_MOUNTED_GAME_OBJECTS['empty mounted fish stand'],
			WALL_MOUNTED_GAME_OBJECTS['sunset painting'],
		},

		decorativeObjects = {
			FISHING_ITEMS['lots of containers'],
			FISHING_ITEMS['yellow_cooler'],
			FISHING_ITEMS['blue_cooler'],
			PLACEABLE_BIG_GAME_OBJECTS['Terrarium'],
			SOLID_GAME_OBJECTS_MISC['Plant palm 2x3']
		},

		hobbyObjects = {
			FISHING_ITEMS['single rod stand'],
			FISHING_ITEMS['multiple rod stand'],
		},
	},



	Average_House = {
		type = "Average House",

		Door = ESCAPE_GAME_OBJECT_DEFS['Door Double Glass'],

		maxNumberOfai = 2,
		minNumberOfai = 1,

		WidthMin = 12,
		WidthMax = 15,

		HeightMin = 12,
		HeightMax =15,

		maxTimeBeforePoliceSpawn = 30,
		minTimeBeforePoliceSpawn = 7,

		houseTileSets = {
		    {walls = "white_house9", floors = "beige_house4"},
		},

		bedsAmmount = {max = 1, min = 1},
		windowsAmmount = {max = 1, min = 2},
		tablesAmmount = {max = 2, min = 1},
		wallMountedAmmount = {max = 2, min = 0},
		decorativeAmmount = {max = 4, min = 2},
		hobbyObjectsAmmount = {max = 2, min = 0},

		bedObjects = {
			SOLID_GAME_OBJECTS_BEDS['Blue_Bed'],
			SOLID_GAME_OBJECTS_BEDS['Plain_Bed'],
			SOLID_GAME_OBJECTS_BEDS['Green_Bed']
		},

		windowObjects = {
			ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Closed'],
			ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Closed'],
			ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Open'],
			LAMP['Fire_Place'],
			ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Open'],
			ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Open'],
		},

		--FISHING_ITEMS

		tableObjects = {
			SOLID_GAME_OBJECTS_TABLES['Table Dark_Wood 3x4'],
			SOLID_GAME_OBJECT_DESKS['Modern Desk White Broad'],
			SOLID_GAME_OBJECT_DESKS['Modern Desk White single'],
		},

		wallMountedObjects = {
			GAME_OBJECTS_MIRRORS['Mirror_Gold'],
			GAME_OBJECTS_MIRRORS['Mirror_Wood'],
			WALL_MOUNTED_GAME_OBJECTS['sunset painting'],
			GAME_OBJECTS_MIRRORS['Mirror_Silver'],
			GAME_OBJECTS_VAULTS['Vault_Locked'],
			WALL_MOUNTED_GAME_OBJECTS['yin-yang painting'],
			WALL_MOUNTED_GAME_OBJECTS['Shark Head']
		},

		decorativeObjects = {
			SOLID_GAME_OBJECTS_SHELVES['Book Shelf1'],
			GAME_OBJECTS_TOYS['Train'],
			PLACABLE_GAME_OBJECT_DEFS['bonzai_tree brown'],
			PLACABLE_GAME_OBJECT_DEFS['bonzai_tree white'],
			LAMP['White_Lamp'] ,
			SOLID_GAME_OBJECTS_SHELVES['Book Shelf3'],
			SOLID_GAME_OBJECTS_MISC['Package'],
		},

		hobbyObjects = {
			SOLID_GAME_OBJECTS_INSTRUMENTS['Wooden Harp'],
			SOLID_GAME_OBJECTS_INSTRUMENTS['Guitar'],
			PLACEABLE_BIG_GAME_OBJECTS['TV_Modern'],
			SOLID_GAME_OBJECTS_CANVAS['Fire place canvas'],
			PLACEABLE_BIG_GAME_OBJECTS['TV_Modern']
		},
	},
	--[[
	Fancy_House = {
		type = "Fancy House",

		Door = ESCAPE_GAME_OBJECT_DEFS['Door Double Glass'],

		--noRooms = true,

		WidthMin = 12,
		WidthMax = 15,

		HeightMin = 12,
		HeightMax =15,

		houseTileSets = {
		    {walls = "white_house9", floors = "beige_house4"},
		    --{walls = "log_Cabin_House3", floors = "log_Cabin_House3"},
		    --{walls = "log_Cabin_House3", floors = "log_Cabin_House3"},
		},

		bedsAmmount = {max = 1, min = 1},
		windowsAmmount = {max = 1, min = 2},
		tablesAmmount = {max = 2, min = 1},
		wallMountedAmmount = {max = 2, min = 0},
		decorativeAmmount = {max = 3, min = 1},
		hobbyObjectsAmmount = {max = 2, min = 0},

		bedObjects = {--SOLID_GAME_OBJECTS_BEDS['Wooden Bed'],
		SOLID_GAME_OBJECTS_BEDS['Plain_Bed'],
		--SOLID_GAME_OBJECTS_BEDS['Green_Bed']
		},

		windowObjects = {ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Closed'],
		ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Closed'],
		LAMP['Fire_Place'], --16% chanvce of spawning
		ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Open'],
		ESCAPE_GAME_OBJECT_DEFS['Window_Blue_Curtains_Open'],
		},

		--FISHING_ITEMS

		tableObjects = {
		SOLID_GAME_OBJECTS_TABLES['Table Fancy 3x4'],
		SOLID_GAME_OBJECT_DESKS['Writting Desk Fancy 2x2']
		},

		wallMountedObjects = {
			GAME_OBJECTS_MIRRORS['Mirror_Wood'],
			GAME_OBJECTS_MIRRORS['Mirror_Silver'],
			GAME_OBJECTS_MIRRORS['Mirror_Gold'],
			GAME_OBJECTS_MIRRORS['Mirror_Gold_Broken'],
			GAME_OBJECTS_VAULTS['Vault_Locked'],
			GAME_OBJECTS_VAULTS['Vault_Empty'],
			GAME_OBJECTS_VAULTS['Vault_Gold'],
			GAME_OBJECTS_VAULTS['Vault_Emerals'],

			WALL_MOUNTED_GAME_OBJECTS['yin-yang painting'],
			WALL_MOUNTED_GAME_OBJECTS['sunset painting'],
			WALL_MOUNTED_GAME_OBJECTS['Shark Head']

		},

		decorativeObjects = {
			GAME_OBJECTS_TOYS['Toy_House'],
			LAMP['White_Lamp'] 
		},

		hobbyObjects = {
			SOLID_GAME_OBJECTS_INSTRUMENTS['Wooden Harp'],
			SOLID_GAME_OBJECTS_INSTRUMENTS['Golden Harp'],

		},
	},]]
}