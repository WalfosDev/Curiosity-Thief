--[[
This is the object class which stores objects.

All objects are defined from object_defs this contains all definitions for all objects. 
These definitions tell the game the quads for the object along with its size and it will even 
tell the game which general area to place the object(under walls ect..). 

This game is completely tile based, because of this the objects are too. So, in procedural generation it scans a 
tile_map of the house and then places the object in a separate objects tile_map.  

Now you might be asking, how did you get objects with a width/height of more than one to be tile based? 
First, I made it so that on the tile_map the object's origin location only takes up one tile. When the tile_map 
is running through tiles to render and an objects origin tile is rendered the object class render function is 
called which renders the whole object. So, when 1 tile is rendered the whole object renders.  

It does this by taking the width and height of the object and sequentially for each width/height it offsets the 
gridX/gridY and QuadX/QuadY by 1 which in turn gives the illusion of a whole object being there. 
There is a specific equation with the QuadX and QuadY such that it gives the actual Quad from the atlas. 

An advantage of this system is that another object can go on top of what appears to be that object as long as it's 
not on the origin tile of the object. The origin tile being the tile that contains the object.  

Using the same system but with gridX and gridY the object class also returns collidable positions. 
The tile_map when looking if something would collide with an object sorts through all the objects in the tile map and c
hecks their collidable positions. 
 
An object's definitions can specify what tiles are collidable on the object, if the object is collidable,
if the object is stealable, the object's general placement, as well as width/height etc.… 
]]
Object = Class{}

function Object:init(def, tileX, tileY, addedPossitionOffsetX, addedPossitionOffsetY)
	--key definitions for stealing the object
	self.name = def.name
	self.stealable = def.stealable
	self.objectsWorth = def.objectsWorth

	--Object position
	self.tileX = tileX
	self.tileY = tileY
	--These are given by game_defs
	self.PositionoffsetX = def.PositionoffsetX or 0
	self.PositionoffsetY = def.PositionoffsetY or 0
	--These are given manually when spawning
	self.addedPossitionOffsetX = addedPossitionOffsetX or 0
	self.addedPossitionOffsetY = addedPossitionOffsetY or 0

	--The X and Y the quad is situated at on the furniture sprite sheet, if it was split into 16x16
	--For example if (X = 2) and (Y = 5) then frame = 21
	self.quadX = def.quadX
	self.quadY = def.quadY
	--Width and Height (how many tiles compose of this object.)
	self.tileWidth = def.tileWidth --Height is below the originX
	self.tileHeight = def.tileHeight --Width is to the right of OriginY

	--Defines wich [parts of the object are collidable if at all, if not defined the whole object is assumed collidable
	self.notSolid = def.notSolid
	self.tilesThatObjectCanCollideWith = def.tilesThatObjectCanCollideWith

	--If true and the player is on this object it makes the player render underneath it instead of on top of it
	self.renderPlayerUnderObject = def.renderPlayerUnderObject

	--if the object can'tbe destroyed
	self.canNotBeDestroyed = def.canNotBeDestroyed
end

function Object:update(dt)

end

--returns the tilePosition of a quad in relation to the games tileMap.
function Object:returnSpecifQuadPosition(tileQuadX, tileQuady)
	positions = {}

	local tileOffsetY = -1

	for y = 1, self.tileHeight, 1 do
		tileOffsetY = tileOffsetY + 1
		local tileOffsetX = -1

		for x = 1, self.tileWidth, 1 do
			tileOffsetX = tileOffsetX + 1
			local tileX = self.tileX + tileOffsetX
			local tileY = self.tileY + tileOffsetY
			if x == tileQuadX and y == tileQuady then
				positions = {x = tileX, y = tileY}
			end
		end

	end

	return positions
end

--returns all grid positions of this object in relation to the tileMap
function Object:returnTilePositions()
	positions = {}

	local tileOffsetY = -1

	for y = 1, self.tileHeight, 1 do
		tileOffsetY = tileOffsetY + 1
		local tileOffsetX = -1

		for x = 1, self.tileWidth, 1 do
			tileOffsetX = tileOffsetX + 1
			local tileX = self.tileX + tileOffsetX
			local tileY = self.tileY + tileOffsetY
			table.insert(positions, {x = tileX, y = tileY})
		end

	end

	return positions
end

--returns all colidable positions of this tile in relation to the timeMap
function Object:returnCollidablePositions()
	positions = {}

	--if the object is not solid then skip this
	if not self.notSolid then

		if self.tilesThatObjectCanCollideWith then
			--This is a list of tiles in the object that the object can collide with
			for k, tile in pairs(self.tilesThatObjectCanCollideWith) do

				local tileOffsetY = -1
				--flips through the objects width and height
				for y = 1, self.tileHeight, 1 do
					tileOffsetY = tileOffsetY + 1
					local tileOffsetX = -1
					for x = 1, self.tileWidth, 1 do
						--adds these values to the position to get it in relation to the maps coordinates
						tileOffsetX = tileOffsetX + 1
						local tileX = self.tileX + tileOffsetX
						local tileY = self.tileY + tileOffsetY
						--if this current tile in the object matches a collidable tile then its added to the tiles to check for collision
						if x == tile.x and y == tile.y then
							table.insert(positions, {x = tileX, y = tileY})
						end
					end
				end
			end

		--if specific tiles aren't specified the whole object is assumed solid
		else
			
			local tileOffsetY = -1

			for y = 1, self.tileHeight, 1 do
				tileOffsetY = tileOffsetY + 1
				local tileOffsetX = -1

				for x = 1, self.tileWidth, 1 do
					tileOffsetX = tileOffsetX + 1
					local tileX = self.tileX + tileOffsetX
					local tileY = self.tileY + tileOffsetY
					table.insert(positions, {x = tileX, y = tileY})
				end
			end
		end
	end--end of not solid check

	return positions
end


--[[
The render function was built such that the object is saved at one tile in a tileMap however it will render the whole object based on width and height.

Now you might be asking, how did you get objects with a width/height of more than one to be tile based?
Well first I made it so that on the tile_map the reall object only takes up one tile. However when this 1 tile is rendered
it renders the whole object, in the Object class. It does this by taking the width and height and sequentially for each width/height it moves
the object on the x/y axis by one tile alonng with changing the quadX/quadY by this value and rendering. Giving the illusion of a whole object being there. 

An advantage of this system is that another object can go on top of what appears to be that object as long as it's not on the origin tile of the object.
The origin tile being the tile that contains the object. 

tileOffset - this is how the tile is actually offseted
quadOffset - this is the quad and how it is offseted when peicing throughh quads
]]
function Object:render()

	--Has these offsets so it mathematically works.
	local tileOffsetY = 2
	local quadOffsetY = -2
	for y = 1, self.tileHeight, 1 do
		tileOffsetY = tileOffsetY - 1
		quadOffsetY = quadOffsetY + 1
		local tileOffsetX = 2
		local quadOffsetX = -1

		for x = 1, self.tileWidth, 1 do
			quadOffsetX = quadOffsetX + 1
			tileOffsetX = tileOffsetX - 1

			love.graphics.draw(gTextures['Furniture'], gFrames['Furniture']
	    	[((self.quadY + quadOffsetY) * 16) + (self.quadX + quadOffsetX)], --Gets the appropriate frame

	    	((self.tileX - tileOffsetX) * TILE_SIZE) + (MAP_RENDER_OFFSET_X  + self.PositionoffsetX) + self.addedPossitionOffsetX, --X pos
	    	((self.tileY - tileOffsetY) * TILE_SIZE) + (MAP_RENDER_OFFSET_Y  + self.PositionoffsetY) + self.addedPossitionOffsetY) --Y pos
		end
	end

end