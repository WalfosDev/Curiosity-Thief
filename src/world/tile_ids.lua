--[[
    Tile_ids.lua contains the ids for the tiles; which is their quad number in the sprite sheet. 
    It also defines the type of tile this tile is, there are 3 tile types: floor, border and wall. 
    A border is an all-white tile that appears to look like the top of the house, the walls appear 
    to be 3d and are usually made up of the upper wall and lower wall, finally the floor is a floor 
    tile which is not counted as a collision. 
]]

-- tile IDs
HOUSE_WALL_TILE_IDs = {
    --[[Quick Definitions: (there are lots of tiles so here are some abrevations for the names)
    T - Top,      R - Right
    B - Bottom,   L - left
    ]]

    --Border tiles
    ["TR_border"] = {id = 11, type = "border"},
    ["TL_border"] = {id = 14, type = "border"},
    ["BR_border"] = {id = 51, type = "border"},
    ["BL_border"] = {id = 54, type = "border"},
    ["R_border"] = {id = 21, type = "border"},
    ["L_border"] = {id = 24, type = "border"},
    ["B_border"] = {id = 53, type = "border"},

    --Wall tiles
    ["Upper_border_wall"] = {id = 12, type = "wall"},
    ["Lower_border_wall"] = {id = 22, type = "wall"},

    --Room tiles

    --Wall that cnnects the two edges
    ["Upper_Room_Wall"] = {id = 12, type = "wall"},
    ["Lower_Room_Wall"] = {id = 22, type = "wall"},

    --edge of a rooms wall on the left side
    ["Upper_Room_Edge-Wall-left"] = {id = 39, type = "wall"},--{id = 39, type = "wall"},
    ["Lower_Room_Edge-Wall-left"] = {id = 49, type = "wall"},--{id = 49, type = "wall"},

     --edge of a rooms wall on the left side
    ["Upper_Room_Corner_Wall"] = {id = 89, type = "wall"},--{id = 39, type = "wall"},
    ["Lower_Room_Corner_Wall"] = {id = 99, type = "wall"},--{id = 49, type = "wall"},

    --edge of a rooms wall on the right side
    ["Upper_Room_Edge-Wall-right"] = {id = 19, type = "wall"},
    ["Lower_Room_Edge-Wall-right"] = {id = 29, type = "wall"},

    --connects the room walls to the top or bottom of the screen
    ["Ceiling_Room_Wall_Top-Border"] = {id = 59, type = "border"},
    ["Ceiling_Room_Wall_Top-Corner"] = {id = 69, type = "border"},
    ["Ceiling_Room_Wall"] = {id = 79, type = "border"},
}

HOUSE_FLOOR_TILE_IDs = {
    --Floor tiles
    ["Unshaded_floor"] = {id = 43, type = "floor"}
}

TILE_EMPTY = 1