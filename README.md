Hello, this is the code for my CS50g final project. I finnished my final project on Dec/10th/2020. The game designed for this final project is called “Curiosity Thief” and is run on the LOVE2D version 0.10.2 windows framework. To start the game just download the game folder and LOVE2D v0.10.2, then drag the game’s folder on to the love.exe icon. 

The project instructions were as follows:    
* Your game must be in either LÖVE or Unity. 
* Your game must be a cohesive start-to-finish experience for the user; the game should boot up, allow the user to play toward some end goal, and feature a means of quitting the game.
* Your game should have at least three GameStates to separate the flow of your game’s user experience, even if it’s as simple as a StartState, a PlayState, and an EndState, though you’re encouraged to implement more as needed to suit a more robust game experience (e.g., a fantasy game with a MenuState or even a separate CombatState).
* Your game can be most any genre you’d like, though there needs to be a definitive way of winning (or at least scoring indefinitely) and losing the game, be it against the computer or another player. This can take many forms; some loss conditions could be running out of time in a puzzle game, being slain by monsters in an RPG, and so on, while some winning conditions may be defeating a final boss in an RPG, making it to the end of a series of levels in a platformer, and tallying score in a puzzle game until it becomes impossible to do more.
* You are allowed to use libraries and assets in either game development environment, but the bulk of your game’s logic must be handwritten (i.e., putting together an RPG in Unity while using a UI library would be considered valid, assuming the bulk of the game logic is also not implemented in a library, but recycling a near-complete game prototype from Unity’s asset store with slightly changed labels, materials, etc. would not be acceptable).
* Your project must be at least as complex as (and distinct from!) the games you’ve implemented in this course, and should really be moreso. Submissions of low complexity may be rejected! You must explain your game in detail and why you believe it to meet the complexity and distinctiveness requirement in a README.md file at the root of your project.

This document outlines why I believe the game designed meets the required complexity and distinctiveness of this course’s final project. It also provides a detailed explanation of the game. **Phase One** of the document will provide a surface level explanation of the game. **Phases Two:** Will provide a detailed explanation highlighting why I believe the game to meet the complexity and distinctiveness requirements. **Phases Three:** Will address the game in detail which will be outlined under the following subheadings: (1)The Game’s State Flow, (2)Controls, (3)Libraries and other material used, (4)The world classes folder and how code is structured, (5)Procedural House Generation Overview, (6)Procedurally making the house, (7)Objects, (8)How objects are procedurally placed, (9)The Entity Class, (10)The PersonAi(residents), (11)The PoliceAi, (12)The Player, (13)Crime rate and police AI spawning, (14)The HouseState,  (15)The LoseState & PauseState (16)The PlayState, (17)The CashInMoneyState & AnimationStates, (18)Overview of all the dialogues, (19)Explanation of the tutorial, (20)Summary. 

**Phase 1: - - - - - - - - - - - - - - - -**  

A Surface level Explanation of the game. My game is Curiosity Thief which is a; top-down, tile based, pixel art, arcade type stealth game. First of all, when you enter the game there is a little dialogue that helps explain the game, and set preferences such as the controls and whether the tutorial should be enabled. Now in the game you play as a Thief who goes from house to house stealing objects and has to sell them in a shop to increase his score(money), however the player must also avoid police and residents. This game has you scoring indefinitely until you lose. The player can press e to steal objects and r to break them. All houses are procedurally generated. The player must avoid the residents (which are ai) because the more the residents see you it increases your crime rate. The crime rate affects the time it takes the police to spawn in the house you are in. When the police spawn they attempt to chase the player and if the police come in a 1 tile radius of the player the game is over, thus showing the game over screen. To go from house to house the player must go from the door that they came from to the exit door, which may be the same door or somewhere else in the house; so essentially the player must also search for a door. Once they reach the new door, they can press e to leave which will teleport them to the next house. Every couple houses the player is offered an opportunity to sell their items or continue stealing to get a multiplier on sales for the next time they sell items. There is also a chance for a dialogue to play whenever the player transitions to a new house. The game provides an in depth tutotial.

**Phase 2: - - - - - - - - - - - - - - - -** 

I believe my game to meet the distinctiveness requirements because it has a completely different game play loop from any other game made during the course. Firstly, I do acknowledge that the Zelda game which was implemented during the course was also a top-down tile-based game however the similarities end there. In my game you play as a thief who goes from house to house stealing objects before the police come, if the police arrive you must evade them and try to escape, else you lose. Which is not similar to Zelda; that has you explore a dungeon and kill entities who block your path. Secondly in no other game developed during the course was there a game play loop of stealing objects and then being chased by police. This is the reason why I believe it to be distinct from any other game made during the course, because it has a completely different game play loop. 


I believe my game to be more complex than any other game implemented during the course because of its ai system, objects, and procedural object placement.   
First the ai not only have a stateMachine but they also have a stateStack to supplement it. The stateMachine is used for handling behaviours while the stateStack is used for handling actions. For example: The PersonAi(residents) usually are in the PersonAidleState, this state scans for the player, makes the AI have random thoughts, and makes them either move in a random direction or stand still. However, to make the as code concise as possible when it makes the AI move in random directions it calls actions on to the AI’s stateStack such as “moveAction(), changeDirectionAction()”. This allows for the AI to do its calculations (which is scanning for the player) without being disrupted by constantly having to change states in the stateMachine. I believe this to be way more complex than the other games because of the AI here have a stateStack and stateMachine which work in tandem, unlike any other AI implemented in the course.  
Secondly the objects in the game were more complex than other object classes explored in the course. Firstly, the object class was made to be tile based such that the objects can fit in a tileMap. Along with this the objects have a host of functionality which come from object definitions such as: the object can define what tiles in the object are collidable, objects being removable and able to be removed from the tileMap. The objects even have properties which tell the player object weather the player should render before or after the object. A case use of this is the tree object, where only the bottom tile of the object is collidable where the pot is, and the player renders under the object because of instructions. So, when the player passes by the object it gives a 3d looking effect, because they were able to go under the part of the object which someone in real life could go behind if it was being viewed from the top-down perspective. See more in the object section.
Finally, I believe it to be more complex because of the procedural object placement. Which I would dare to call intelligent placing. First I would like to prefix that intelligence is defined as the ability to acquire and apply knowledge and skills. This mechanism analyzes the already made houseTileMap (acquiring Knowledge) and places the objects accordingly (applying knowledge). How it works is that objects can define what area type that they should be placed. Now the objects are placed using SolidObjectsMaker which takes in the HouseTileMap and returns a tileMap of its own containing objects.  First it analyses the house tileMap for the different area types. These are:
Tile Type -- description  
Underneath Wall Tiles --which are characterised by having 2 walls in a row, because we can deduce under the wall there will be a floor. 
Floor Tiles -- which are characterised by having the tile and the tile behind it being a wall
Middle of Floor Tiles -- which are characterised by having 1 tile away from all walls or borders 
Corner Floor Tiles -- which are characterised by having a tile that's on a floor and has walls on at least 2 sides of the tile. 
Bottom of Floor Tiles --which are characterised by having a tile that has a border underneath it  
Then it randomly chooses an object from a list of objects and puts it on a random tile from the area type specified, however before the object is placed into the tilemap it will first perform various checks to see whether the object can spawn. These include: 
-Object is not inside the map 	 
-Object is inside another object   
-Object is blocking a corridor, or is blocking the player's path 
-Object is blocking the door 
-Object is blocking a room 		   
-Object is inside wall 
If all of these tests come out negative then the object is spawned. This whole system makes a house look organised. For example lamps, you normally find lamps in the corners of houses so the lamp area type is “corner floor tiles”, or dinner tables which you usually find in the middle of rooms so it’s area type is “Middle of floor tiles”, finally drawers are normally found leaned against walls so their area type is “underneath walls”. I believe this system to make my game more complex than the others implemented before because not only is this procedural generation but it is highly precise procedural generation which brings a high level of organisation to my game, and I believe that in no other cs50 project was their procedural generation so demanding and complex. 
In all I believe my game to be more complex than any other implemented during the course because of its ai system which has a stateMachine and stateStack which complement each other, the objects being tileBased, and finally because of procedural object placement being highly organised.  

 
**Phase 3: - - - - - - - - - - - - - - - -** 

**(1) The Game’s State Flow.** The game starts in the TitleScreenState then if play is pressed it goes to the OpeningDialogue which leads to the Playstate. From the playstate it may either go to an AnimationState, cashInMoneyState(if the player has robbed a certain number of houses) or HouseState(where the actual gameplay takes place), all these states go back to the playstate as the playstate is the core of the game. In the HouseState if the player presses P then it goes to the pauseState else if the police come in a 1 tile radius of the player it goes to the loseState. Other States include the dialogueState; and fadeState which is used quite a lot in transitions. The game states are handled by a stateStack. 



**(2) Controls.** By default in selection screens you press w and s to change selection, press enter to continue. However, you can change this in the openingDialogue such that it is an up and down arrow. You can also press enter to continue dialogue. Based on your choice in the openingDialogue you either use "W A S D" to move or the "up down left right" arrows. Press E to steal, and interact with doors to leave the house. However, you cannot interact with the door you spawned at, unless there is only one door in the house, however there are usually two doors which spawn at the far ends of the house. You can also press R to destroy most objects. Finally, you can press P to pause the game. 



**(3) Libraries and other material.** From this point on I will start going into the code behind the game. But before I get into that I would just like to state all code files that are not made by me. These include the: The Knife ecosystem, push library, class library, all items in the gui folder (though they have been modified to fit my purposes), the animation class, Util.lua, stateStack class, and finally the StateMachine class.  

First the knife ecosystem helps with performing simple tasks that take a lot of code to manage (such as timers, tweening etc…). Then the push library helps achieve the arcade pixelated effect when rendering, it allows there to be a virtual_width and virtual_height which is the pixel width and height, for example: if I want my game which has a window_width * window_height of 1280 * 720 pixels to appear to have a width * height of 204 * 128 pixels while still maintaining the screen size the push library allows that to happen, it also makes sure all edges/shapes are sharp and pixelated. Next the class library allows my code to be object oriented containing classes. The gui folder was taken from cs50 assignment 7 pokemon which I found perfectly fits my game, it allows for my game to have GUI elements/classes to it, such as dialogue and selection screens. The animation class was taken from cs50 assignment 5 Zelda it assists with the animations, I found it was the most appropriate animation class for my game. Util is taken from cs50’s match-3 assignment and is used to piece out quads from sprite sheets. Finally, The StateMachine and StateStack class allow for my game to have multiple game state’s and a state flow.  

Though it may sound like a handful these classes/libraries only helped to bootstrap my game so that further development could be done efficiently. In no way do they comprise the bulk of my game. 



**(4) The world folder and how the code is structured.** Thanks to the libraries the code is structured such that it is entirely object oriented, with it containing many states which are managed by a StateStack. Some foundational classes for my game’s core game play are found in the src/world folder. These classes help with making the game tile based. These classes include: 

Tile.lua is the class for tile objects, it renders a specific tile, keeps track of its position and type (floor, wall ect…). 

Tile_ids.lua contains the ids for the tiles; which is their quad number in the sprite sheet. It also defines the type of tile this tile is, there are 3 tile types: floor, border and wall. A border is an all-white tile that appears to look like the top of the house, the walls appear to be 3d and are usually made up of the upper wall and lower wall, finally the floor is a floor tile which is not counted as a collision. 

Technically the Object class should also be in this folder as objects are also treated as tile’s, however I thought it was more appropriate to keep it in src.  

Finally, the Tile_map class stores Tile objects and Object objects, in a tile_map so that they can be rendered to the screen or inquired. The inquiries that may be taken from this class include: the return of a specific tile/object from a grid position, check for collisions on a specific coordinate, and to remove a tile from a specific coordinate. 


 
**(5) Procedural House Generation Overview.** This game is completely tile based, and a house is the area that the player plays in. I wanted the game to be able to make multiple different types of houses so I composed the game such that it can take a list of definitions and convert that into a house. To do this I made 4 different classes: HouseMaker, SolidObjectMaker, house_defs, and game_object_defs.   

House_defs defines what furniture can be added into any given house type, how much of each type of furniture as well as the colour of the walls and floors, and how the house is structured. The HouseMaker takes the structural definitions and makes a tile_map containing all the tiles that compose the house's base.The SolidObjectMaker takes the definitions from house_defs that indicates which type of furniture to place and how much furniture to place and inserts the furniture into its own tile_map. The furniture is taken from the game_object_defs. 

The HouseMaker and SolidObjectMaker feed their Tile maps into the Tile_map class, which exists as two separate tile_maps in the HouseState. The houseTileMap is made first because the SolidObjectMaker analyzes the house tileMap’s data to place objects. 

 

**(6) Procedurally making the house.** This is done in the HouseMaker class. It is used to help make a house's foundation. How the house maker works is that as you initialize this class a tile_map and a house base is made, with it being the width and height defined from house_defs as well as using the tile_set defined for the walls and floors(tilke set being house texture). From then on you can call functions to modify the house's base. E.g.: add more rooms etc… Once that is done, call HouseMaker:ReturnHouse() and the house's tile_map will be returned, with it being returned as an object from the tile_map class. It will thus be ready for use and you would only have to call TileMap:render() 

The functions to modify a house can be split into 2 categories that I made up which are: intelligent functions and more hands on functions. Intelligent functions do all the generation for you whereas more hands on functions must be hand defined.  

Houses are made by an intelligent function taking the definitions and calling other functions to manufacture the house. The intelligent function is ProcedurallyGenerateRooms().  Now how the house is made varies from house_definitions but basically here is the gist. 

The game has a table of room points, which are defined as follows: 
self.roomPoints[self.currentRoomNum] = { 
    bottomY = Lowest vertical point 
	topY = Highest vertical point 
	X = The x defines the x axis 
} 

From then on once this is defined, a other function will be called, such as BuildWallOnyAxis() which takes this latest addition to the table above and connects a wall. Which in this case modifies the tileMap such that it makes a vertical wall staring at (X, bottomY) and stretches to (X, TopY). This system is quite useful because if I call BuildWallOnyAxis() and BuildWallOnxAxis(), it will connect walls to the X,BottomY coordinate and thus make a whole room.  

As these walls are made the tiles in the base house are replaced with new tile objects. Tile onjects take in defininitions from tile_defs. The only thing that changes is the texture derived from the tileSet use, which are all generally the same but with different colors, so the definitions can work for all tile sets.

Though you may be asking why is there no second X point such that a wall stretches from x1 to x2. This is because horizontal walls always connect to from the X point to either the right or left end of the room.   

Openings can be made in the wall to make a doorway to go to the next room, this can be done in the arguments of both the BuildWallOnyAxis() and BuildWallOnxAxis() functions. 

When building walls on the y axis the last 2 tiles by the bottomY are wall tiles while the rest are ceiling(border) tiles which gives the game a 3d effect.

Now back to the ‘intelligent’ function ProcedurallyGenerateRooms() this function generally takes the space left in the house after walls were built and adds more walls if there is space. These are added based on house type specification. For example, the Shed houseType builds a vertical wall with an opening in it every 8-10 tiles. 


 
**(7) Objects.** All objects are defined from object_defs this contains all definitions for all objects. These definitions tell the game the quads for the object along with its size and it will even tell the game which general area to place the object(under walls ect..). 

This game is completely tile based, because of this the objects are too. So, in procedural generation it scans a tile_map of the house and then places the object in a separate objects tile_map.  

Now you might be asking, how did you get objects with a width/height of more than one to be tile based? First, I made it so that on the tile_map the object's origin location only takes up one tile. When the tile_map is running through tiles to render and an objects origin tile is rendered the object class render function is called which renders the whole object. So, when 1 tile is rendered the whole object renders.  

It does this by taking the width and height of the object and sequentially for each width/height it offsets the gridX/gridY and QuadX/QuadY by 1 which in turn gives the illusion of a whole object being there. There is a specific equation with the QuadX and QuadY such that it gives the actual Quad from the atlas. 

An advantage of this system is that another object can go on top of what appears to be that object as long as it's not on the origin tile of the object. The origin tile being the tile that contains the object.  

Using the same system but with gridX and gridY the object class also returns collidable positions. The tile_map when looking if something would collide with an object sorts through all the objects in the tile map and checks their collidable positions. 
 
An object's definitions can specify what tiles are collidable on the object, if the object is collidable, if the object is stealable, the object's general placement, as well as width/height etc.… 

 

**(8) How objects are procedurally placed.** Now that I have explained the object, I will explain how objects are placed in the game. I would say that objects are placed using an intelligent placing system. First, I would like to prefix that intelligence is defined as the ability to acquire and apply knowledge and skills. This mechanism analyzes the already made houseTileMap (acquiring Knowledge) and places the objects accordingly (apply knowledge). 

The intelligentGeneration works in tandem with game_object_defs and house_object_defs. 
-game_object_defs is the script filled with the game object definitions. The game_object_defs gives the script info on: Where object should spawn, anything that happens after spawning, and other spawning info. 
-house_object_defs is the script that tells us what the house should be like: The house_object_defs gives the script information on: How many of each object type should spawn, what object should spawn in this house type. 

This script takes this information and then places the objects accordingly. 
The step-by-step process is: 
(a)intelligentlyGenerateObjectss() method takes the houseType and gets the houseDefinitions. Using these definitions, it determines; how many of each object should spawn for each type, and the list of objects it can choose from for each type. 
(b)It feeds this information into generateObjects() on a type-by-type basis. 
(c)In generateObjects() a random object is chosen from the list of the object type. Based on the area spawning information from this object's definitions it is then put to spawn using the randomlyPlaceObject() method. However, if it fails to spawn then a different object is chosen from the list and this process will repeat a maximum of 3 times. Once the first object is spawned it goes onto spawn the next object based on the amount of this type of object that should spawn. 
(d)In the randomlyPlaceObject() method it takes the area type and from the object given chooses a random tile from the area type. Once position is chosen it will adjust this position based on object type and perform various checks. Then the objects are put through into the spawnObject() method which takes in the object and performs many checks to see if it can spawn (example; object isn't in wall; object isn't in another object etc...). If the object can spawn it is spawned. It returns a true value to the randomlyPlaceObjectMethod and from there the method goes into the objects_defs and see if there was any behavior to be done when the object is spawned. However, if the object failed these checks it is given another try to find a different tile to spawn on repeating this process. 
(e) Else if the object spawned the method has done its work and the generateObjects method goes to the next object since it got a true value on the object spawned.  
 
Here is how it figures out the area type:
How it works is that objects can define what area type that they should be placed. Now the objects are placed using SolidObjectsMaker which takes in the HouseTileMap and returns a tileMap of its own containing objects.  First it analyses the house tileMap for the different area types. These are:
Tile Type -- description  
Underneath Wall Tiles --which are characterised by having 2 walls in a row, because we can deduce under the wall there will be a floor. 
Floor Tiles -- which are characterised by having the tile and the tile behind it being a wall
Middle of Floor Tiles -- which are characterised by having 1 tile away from all walls or borders 
Corner Floor Tiles -- which are characterised by having a tile that's on a floor and has walls on at least 2 sides of the tile. 
Bottom of Floor Tiles --which are characterised by having a tile that has a border underneath it  
Then it randomly chooses an object from a list of objects and puts it on a random tile from the area type specified, however before the object is placed into the tilemap it will first perform various checks to see whether the object can spawn. These include: 
-Object is not inside the map 	 
-Object is inside another object   
-Object is blocking a corridor, or is blocking the player's path 
-Object is blocking the door 
-Object is blocking a room 		   
-Object is inside wall 
If all of these tests come out negative then the object is spawned. This whole system makes a house look organised. For example lamps, you normally find lamps in the corners of houses so the lamp area type is “corner floor tiles”, or dinner tables which you usually find in the middle of rooms so it’s area type is “Middle of floor tiles”, finally drawers are normally found leaned against walls so their area type is “underneath walls”.

**(9) The Entity Class.** All entities in my game inherit properties from the entity class which keeps track of and performs basic entity functions such as: rendering, grid positions, positions, state machines, speed, texture, animations, current animation frame etc.… The entities in my game are mostly humans which have a height of 2 tiles so the class is oriented towards this. In addition, the entity class contains; (a)More complex rendering, (b)A stateStack and (c) Ai analysis functions, all of which I will now explain. 

(a)When I say more complex rendering the entity class makes it such that the game can render the top half and bottom half of the entity separately. You may ask what purpose does this serve? Well objects in the game can pick specific tiles on them that are collidable, this is good because it allows the entities to pass through parts of objects that you can normally in real life, making a more realistic 3d effect. Example: There is a tree object in the game, however only the bottom tiles of the tree are collidable because that is where the plant pot is, the player can pass behind the rest of the tree because it isn’t collidable giving a 3d effect. Now here is where the rendering comes into play, the objects also have a definition that dictates whether the player should render before or after the object that the player is currently on it. There is a function in the entity class :checkWheatherEntityShouldRenderBeforeOrAfterObjects(objectTileMap) that sorts through the object tile map and checks the entity location for this information. To make it even more realistic it checks the bottom and top half of the entity separately activating specific variables such as renderBottomBeforeObjects and  renderBottomBeforeObjects. Now the state that houses the game play(houseState) will use the variables to render the bottom half and top half of the entity separately either before or after objects based on these variables. 
The bottomHalf and topHalf are rendered separately because the player's head may be on an object that says to render after the object while the bottom half may say to render before the object. To avoid this issue, I made the bottom and top half of the player render separately. In all making the game look very 3d. 

(b)As I said earlier the entity class also has an optional stateStack which is used for ai, so now the AI can have 2 stateMachines. This allows for the AI to have more complex behaviour. How I designed it is such that the stateMachine of the ai normally takes care of general behaviours while the StateStack takes care of actions. These actions can be found in src/states/entity/enemyAi and they include: 
MoveAction - purely moves the entity forward if there are no collidable positions in front (checks both object and house tile maps) 
MultiAction - moves the entity and can change entities direction simultaneously 
ChangeDirectionAction - purely changes the entities direction 
ActionSetStart	- starts the action set 
ActionSetFinnished - Indicates the action set has been finished 
I wanted the actions to only start once the whole stack has been compiled so that then the stack slowly takes actions off. To do this I made it so that the action only starts on entering the state which is different from initializing the state, in that to enter the state is for the state above it to pop, so you only enter an already initialised state. To do this all of the actions have their actual action in their enter function while the init function just takes in directional info. Once your stack is compiled you push ActionSetStart state on top of it which then causes the stack to begin with actionSetStart immediately popping itself off the stack so the stateStack enters the next state on the stack. Finally, the actionSetFinished makes the actionSetComplete variable in the ai be set to true, so that the other stateMachine knows when this action set was completed. 

This is a very useful system because the stateMachine can always keep scanning and doing more computational work and only call actions on to the stateStack to move the entity so that the behaviors process never has to be broken. 
 
(c)Other ai functions are related to analyzing the tileMaps and other entity grid positions in relation to them. The simplest of these is the function isEntityInDirectView() which scans for whether the entity the game is trying to find is directly in front of this entity. However, since it is in view, if an opaque object or tile that’s type is wall, is encountered then scan stops checking any further. However, in the game there are upper and lower walls and the entity head can go on the upper wall which may make the algorithm think there is a wall ahead so instead, the game scans the y axis of the bottom half of the entity which should always be on the floor. 
 
A function that is a step more advanced is the isEntityInView() function. This function is used to check whether an entity is in view of this current entity. Entities have a view which is in a pyramid formation starting from the entities foot. This function scans for another entity in a pyramid like formation, however it has some added features to make the view more realistic. These are: 
(1) Once an opaque object (object you can't see past) or a wall is detected then this entity stops scanning on that specific axis depending on direction. Example: This entity is looking to the right and sees a wall on (y2, x5) it will no longer scan for the players on y2. 
(2) If an object is detected on the edges of the pyramid scan view then the pyramid will no longer grow on that edge. This ensures that the entity can't see pasts corners. Example: This entity is facing right and encounters a wall on y6 which is the bottom edge of the pyramid at this current stage, all tiles past y6 will not be scanned. 

The function acts a bit differently for when this entity is facing; (up and down) or (left and right). Because of the axises being switched however they essentially achieve the same purpose. 
By the way the pyramid view is such that it scans 1,3,5,7... tiles in a pyramid like formation from the foot. 

 

**(10) The PersonAi(residents).** Now that I have explained the entity class, I can start explaining specific entities that inherit from that class. Firstly, I will explain the gist of this entity. This is an ai that spawns when the house is initialised and is found in random locations in the house and are the inhabitants of the houses. They can be seen walking in random directions in the house while doing something (such as thinking, talking on the phone) which are represented by thought bubbles by the entity's head, this is all in the PersonAidleState. If the entity see’s the player ie: the player is in the entities view then the AI switches to the PersonAiFleengState which makes the entity appear to panic, sometimes pacing back and forth really fast, at the same time their thought bubble switches to an exclamation mark. The player's crime rate increases any time this happens (the entity see’s the player). So basically, the player needs to avoid being seen by this ai. 

To have these thought bubbles the personAi has a renderThought() function and changeThoughtAnimation() function so that when the personAi renders so does the thoughtAnimation, which comes from an Entity_Thought sprite sheet. 

The PersonAidleState just picks a random action to do: standStill or randomlyWalk, based on this it chooses an appropriate thought animation and calls the correct actions onto the AI’s stateStack. Whenever the action set is indicated as complete by the actionSetComplete variable then this process is repeated. Alongside this the states update function always calls the isEnityInView(player) function on the ai it’s managing, if it returns true for seeing the player then the stateMachine switches to the PersonAiFleeingState. 

The fleeingState; clears all actions off of the stack, changes the entities thought to an alarmed expression, and increases the players crime rate. After that the entity stays still for 2 seconds before choosing whether it should continue to stay still or do a pacing up and down movement. If it does a pacing up and down movement the ai’s speed increases and some actions are added onto the stateStack to make the ai pace up and down. 



**(11) The PoliceAi.** The police ai is an ai that spawns once the timeTillPoliceSpawns timer reaches 0. The police are AI that try to touch the player, which causes the player to lose the game. The police only need to be in a 1 tile radius of the player for the player to lose. The policeAi only has 1 state which is the PoliceAiSearchingState.  The most complex part about the ai is how they locate the player.  
First the AI player Ghost, which means it follows the exact path the player took throughout the house.  How it works is that the player has a table playerGhostPath, and everytime the player moves in a house the direction the player moved is added to the table. When the police spawn it runs through the first 40 movements the player made, and puts it on the Ai’s stateStack. This table is run in reverse since a stateStack does the last added movement first. Ex: Run,Run,Left,Run, if this sequence was added to the stateStack as is it would result in the stack doing Run,Left,Run,Run. The player ghost function only runs through the first 40 movements because if the player has too many movements it can cause the game to freeze as the computer adds all the movements to the stack, which disrupts the update function. Once this stack is completed the game player Ghost again with the next 40 tiles the player took.  

However, playerGhosting isn’t enough for the police to get the player cause the player could just run-in circles so to supplement this system there is also a locatePlayer function which tries to find the player in a certain radius of the police. Once the player has been found the police immediately walk towards them.  

The detection process goes like this and is separate for the vertical(y) and horizontal(x) axis, here is how the Vertical axis scans: 
(a)The games store the police’s original positions 
(b)The police’s direction is manually changed to look right 
(c)The police are moved -3 tiles down from its current y to 3 tiles above its current y, on each movement it scans for the player, by using the isEntityInDirectView() function. 
(d)If the player was seen, the number of tiles away from the center on y axis is recorded, the direction to see the player is recorded, and how far away the player is from this new position. 
(e)The policeAi goes back to its original position and since no action was used it looks as if nothing happened to the ai. 
(f)This information is then made into an action set and put on a stateStack. 
(g)If the player wasn’t seen this process is repeated on the left side. 
(h)end of function 
The steps are essentially the same horizontally except replace left and right with up and down, and reverse the axises. From then on, the police Ai uses this new path to get to the player. 

 

**(12) The Player.** The player is interesting in that the class is made in the playState however it only initaliezes the player character and entity in the houseState with the initialiseCharacter() function which is found in player. However, the player does inherit from the entity class. 

First in the playState the player class holds information such as crimeRate, tutorial, stolenObjects etc… Then in the houseState the character is initialized. The player only uses a stateMachine and does not use a stateStack. The player only has 2 states, the idleState and walkState.    

The idleState allows the player to steal or break objects along with putting the player in the walkingState when movement buttons are pressed.  

The walkState checks whether the player can move in a specified direction, it makes sure the player doesn’t collide with objects by checking both the houseTileMap and objectTileMap for collidable positions. Then it updates the players gridY/gridX and tweens the player to this new tile while playing an animation. Then it puts the player back into the idleState. If the player was able to move the movement was recorded in the playerGhostPath table for the police ai to use later. 

Both states check whether the player should render before or after objects using the function found in the entity class that player inherits from. 

As I said the player can also steal objects. As the player moves around the idleState will scan the tile infront the player on the object tileMap and check if it is stealable. If it is stealable the canStealObject variable is set to true which makes a the UI element in the house state indicate that the player can steal the object. Then if player presses e the object is added to the list of stolen objects and removed from the tileMap. 

To break objects the idleState just checks if the object canBeRemoved then removes it from the tileMap and increases the players crime Rate.


**(13) Crime Rate and Police Spawning.** Now I am sure you heard me say crimeRate a lot, so now I will explain it. The crimeRate is used to determine how much time the player has in the house until the police arrive. In the code it is know as variable crimeCoefficient which is found in the player class. The crime rate increases everytime a PersonAi see's the player or the player breaks an object. The max crime rate (maxCrimeCoefficient) is defined in the player class as well, this just helps determine how much time the pplayer has left and is not an actuall cap.

The time the player has left is determined by the house_defs and crimeCoefficient. The house_defs outlines the maximum and minimum time the player has in the house. The time till poice spawns is a result of the percentage of crimeCoefficient against maxCrimeCoefficient, with a higher crime rate giving less time. The equation is as follows:
TimeTillPoliceSpawns = maxTime - ((currentCrimeRate/maxCrimeRate) * maxTime)

However if the result is smaller than the minimum time the player has in the house then the minimum time the player has in the house is the TimeTillPoliceSpawns. Every value over the maxCrimeCoefficient causes more police to spawn.



**(14) The HouseState.** Now that I have covered all the classes of my game it is now time to move on to the actual states. First, we will start with the HouseState where the actual game play takes place. 

When the houseState is initialised it picks a random houseType from the house_defs then it works out the houses; width and height and houseTileSet(texture for walls and floors). Then it calls houseMaker which makes the houseTileMap, then it chooses a random location on the walls to place the doors based on the tileMap, then it makes the SolidObject tileMap with SolidObjectMaker, then it initialises the player character as well as personAi, before finally working out the timer that dictates when the policeSpawn. 

It takes all these components and updates them in the update function as well as providing the pause functionality, being able to exit house if the player is on the same tile as the door and has pressed e, and making the game over when the police come in contact with the player. Additionally, it uses love.graphics.translate to move the camera relative to the player such that the player is always in the center of the screen, however it stops this at the edges of the map. 

Finally, it renders the houseTileMap, then it renders each entity individually before or after the objectsTileMap depending on their variables (such as renderTopBeforeObjects). Finally, it also renders the ui element on top the screen that indicates: Time left, Whether the player can steal an object and Crime Rate.

With the houseState updating all these moving parts it causes the game to work. I also mentioned doors whenever the player is on the same tile as the exit door if the player presses e the state is popped and it goes back to the playState. 

 

**(15) The LoseState & PauseState.** From the houseState the loseState and pauseState can be pushed onto the stack.  

When P is pressed the pauseState is pushed onto the stack. From there you can exit the game or resume. The pauseState shows the players money, total objects stolen, houses robbed and the current number of objects stolen. The background is taken from the brickBackGround Class. When resume is pressed this state is popped and the playState is re-entered.  

The Lose state is pushed onto the stack when the PoliceAi comes in a 1 tile radius of the player. The lose state fades the screen to red and shows your score as well as having a little dialogue. You can choose to leave the game or restart, when you restart it pops all the states including the playstate and then pushes a new playstate re-initializing the player essentially. 

 
 
**(16) The Playstate.** Now as I said earlier all states initialized after the opening dialogue lead back to the playState. The playState basically organizes the game and calls different states onto the stack at the appropriate times. When the playSate is initialized it also initializes the player class, it is initialized here so that info on how many houses the player has robbed etc... is only lost when the player exits the game or the playState is popped. 

Firstly, the playstate will always push the houseState unless it pushes another state before. When the player exits the houseState the game enters back into the playState which in turn pushes another houseState and increases the amountOfHousesThePlayerRobbed variable. After a few houses have been robbed the player is offered to go into the cashInMoneyState to sell items, or they can continue robbing to get a multiplier on the next time they sell items. This is done using a menu GUI. After that the process is repeated so after another few houses the player will be offered to sell their stuff. 

Occasionally under certain conditions the playState may push an animation from the animationStates. 

 
 
**(17) The CashInMoneyState & AnimationStates.** First I will begin with the cashInMoneyState. This state displays all the items the player has stolen and their value, which it gets from the player's itemsRobbedTable. The player can press w & s to scroll through all items. The state then totals it up at the bottom. If there is a multiplier when enter is pressed this multiplier is added onto all values of the stolen objects. Finally, when enter is pressed again this total value of all the objects is added to the total money the player has. 

AnimationStates are found in the animationStatesFolder and house dialogues and cutscenes for the game.  

 

**(18) Overview of all the dialogues.** There are 3 dialogues in the game that function very similarly. Actual dialogue is done with the diologueState. These states constantly keep pushing new dialogue until the dialogue is completed and makes background. Example:  

HighCrimeRateDiologue state first initializes a background and renders a big version of the character talking on the screen, then it pushes the DiologueState with some dialogue, which then pops. When the stateStack re-enters this state a variable, numberOfTimesEntered increases by 1, and based on the value of this variable another dialogue is pushed until eventually it reaches a number that causes the state to be exited. 

Overview of what each dialogue is about: 

DeveloperCommentsDiologue - gives some developers remarks on the game, can be activated by pressing developer comments in the TitleScreenState 

HighCrimeRateDiologue - A cool dialogue that indicates to the player their crime rate is high, activates when the crime rate is over the max crime rate 

OpeningDialogue - This is the dialogue activated on play, it gives an overview of the game as well as asking the player some preference questions (tutorial, controls) using the menu GUI. Then it feeds this information into the playState. 

 
 
**(19) Explanation of the tutorial.** The tutorial is activated when the player chooses it in the opening dialogue. This causes the playState to initialize the player with the tutorial argument being set to true. Then the player initializes the TutorialManager class.  

The TutorialManager manages all the dialogue and controls for the tutorial to work. The player must simply call the updateTutorial(action,stateInfo) function in houseState enter (), houseState init(), cashInMoneyState enter (), and cashInMoneyState init(). This function found in the player class then calls the tutorial manager to update itself. The tutorial dialogues work much in the same way as other dialogues in that every time the state is entered a value increases and for each specific value there is a dialogue.

The tutorial explains the following; movement, stealing, breaking objects, crime coeeficient, the gui panel and selling objects.

**(20)Summary.** Curiosity Thief is a game where at it's core you evade AI (people and police ai) and steal object in proceduraly generated houses, to then cash them in later and if the police come in a 1 tile radius of the player they lose. It contains a few diologues as well as a tutorial to enhance the experience. It is a game that is completely tileBased and has many different system to make it work such as stateMachines and stateStacks.
