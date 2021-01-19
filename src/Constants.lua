--[[
    Constants and global variables in the game.
]]

--These are actually not constants but for convenience I will keep them here
VIRTUAL_WIDTH =  204--272 
VIRTUAL_HEIGHT = 128--192 

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16

MAP_RENDER_OFFSET_X = 16
MAP_RENDER_OFFSET_Y = 16

-- map constants
MAP_WIDTH = VIRTUAL_WIDTH / TILE_SIZE - 2
MAP_HEIGHT = math.floor(VIRTUAL_HEIGHT / TILE_SIZE) - 2

--player controlls
moveUp = 'w'
moveDown = 's'
moveRight = 'd'
moveLeft = 'a'
