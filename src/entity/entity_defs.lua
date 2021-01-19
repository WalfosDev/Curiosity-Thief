--[[
These are the definitions for the various entities.
All frames listed here are the top frames, we manually get the bottom frames by: top + 16
Because the top and bottom of the entities are rendered seperately.

]]

PLAYER_DEFS = {
	['Roki'] = {
        width = 16, 
        height = 32,
        texture = 'character_idle',
        speed = 0.2,

        animations = {
    	    ['walk-left'] = {
                frames = {14,15},--{15,14,13},--{14,15},
                interval = 0.15,
                texture = 'Roki_run',
                frameWidthOfAtlas = 24
            },
            ['walk-right'] = {
                frames = {2, 3},--{1,2,3},--{2, 4},
                interval = 0.15,
                texture = 'Roki_run',
                frameWidthOfAtlas = 24
            },
            ['walk-down'] = {
                frames = {20,23},
                interval = 0.15,
                texture = 'Roki_run',
                frameWidthOfAtlas = 24
            },
            ['walk-up'] = {
                frames = {8, 11},
                interval = 0.15,
                texture = 'Roki_run',
                frameWidthOfAtlas = 24
            },
            ['idle-left'] = {
                frames = {3},
                texture = 'Roki_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'Roki_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-down'] = {
                frames = {4},
                texture = 'Roki_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-up'] = {
                frames = {2},
                texture = 'Roki_idle',
                frameWidthOfAtlas = 4
            },
        }    
    }, --end of Roki

    ['Dan'] = {
        width = 16, 
        height = 32,
        texture = 'character_idle',
        speed = 0.3,

        animations = {
            ['walk-left'] = {
                frames = {14,15},--{15,14,13},--{14,15},
                interval = 0.15,
                texture = 'Dan_run',
                frameWidthOfAtlas = 24
            },
            ['walk-right'] = {
                frames = {2, 3},--{1,2,3},--{2, 4},
                interval = 0.15,
                texture = 'Dan_run',
                frameWidthOfAtlas = 24
            },
            ['walk-down'] = {
                frames = {21,22},
                interval = 0.15,
                texture = 'Dan_run',
                frameWidthOfAtlas = 24
            },
            ['walk-up'] = {
                frames = {8, 11},
                interval = 0.15,
                texture = 'Dan_run',
                frameWidthOfAtlas = 24
            },
            ['idle-left'] = {
                frames = {3},
                texture = 'Dan_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'Dan_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-down'] = {
                frames = {4},
                texture = 'Dan_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-up'] = {
                frames = {2},
                texture = 'Dan_idle',
                frameWidthOfAtlas = 4
            },
        }
    } --end of Dan

}

NPC_DEFS = {
    ['Police'] = {
        width = 16, 
        height = 32,
        texture = 'Police_idle',
        speed = 0.15,

        animations = {
            ['walk-left'] = {
                frames = {14,15},--{15,14,13},--{14,15},
                interval = 0.15,
                texture = 'Police_run',
                frameWidthOfAtlas = 24
            },
            ['walk-right'] = {
                frames = {2, 3},--{1,2,3},--{2, 4},
                interval = 0.15,
                texture = 'Police_run',
                frameWidthOfAtlas = 24
            },
            ['walk-down'] = {
                frames = {20,23},
                interval = 0.15,
                texture = 'Police_run',
                frameWidthOfAtlas = 24
            },
            ['walk-up'] = {
                frames = {8, 11},
                interval = 0.15,
                texture = 'Police_run',
                frameWidthOfAtlas = 24
            },

            ['idle-left'] = {
                frames = {3},
                texture = 'Police_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'Police_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-down'] = {
                frames = {4},
                texture = 'Police_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-up'] = {
                frames = {2},
                texture = 'Police_idle',
                frameWidthOfAtlas = 4
            },

            ['shoot-left'] = {
                frames = {3},
                texture = 'Police_Shoot',
                frameWidthOfAtlas = 4
            },
            ['shoot-right'] = {
                frames = {1},
                texture = 'Police_Shoot',
                frameWidthOfAtlas = 4
            },
            ['shoot-down'] = {
                frames = {4},
                texture = 'Police_Shoot',
                frameWidthOfAtlas = 4
            },
            ['shoot-up'] = {
                frames = {2},
                texture = 'Police_Shoot',
                frameWidthOfAtlas = 4
            },

        }    
    }, --end of Police

    ['Bob'] = {
        width = 16, 
        height = 32,
        texture = 'Rob_idle',
        speed = 0.5,

        animations = {
            ['walk-left'] = {
                frames = {14,15},--{15,14,13},--{14,15},
                interval = 0.15,
                texture = 'Rob_run',
                frameWidthOfAtlas = 24
            },
            ['walk-right'] = {
                frames = {2, 3},--{1,2,3},--{2, 4},
                interval = 0.15,
                texture = 'Rob_run',
                frameWidthOfAtlas = 24
            },
            ['walk-down'] = {
                frames = {20,23},
                interval = 0.15,
                texture = 'Rob_run',
                frameWidthOfAtlas = 24
            },
            ['walk-up'] = {
                frames = {8, 11},
                interval = 0.15,
                texture = 'Rob_run',
                frameWidthOfAtlas = 24
            },
            ['idle-left'] = {
                frames = {3},
                texture = 'Rob_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'Rob_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-down'] = {
                frames = {4},
                texture = 'Rob_idle',
                frameWidthOfAtlas = 4
            },
            ['idle-up'] = {
                frames = {2},
                texture = 'Rob_idle',
                frameWidthOfAtlas = 4
            },
        }    
    }, --end of Bob

}

NPC_THOUGHT_ANIMATIONS = {
    ['nothing'] = {
        frames = {17},
        texture = 'entity_thoughts',
    },
    ['alarmed'] = {
        frames = {15},--{15,14,13},--{14,15},
        texture = 'entity_thoughts',
    },
    ['question'] = {
        frames = {16},--{1,2,3},--{2, 4},
        texture = 'entity_thoughts',
    },
    ['phone'] = {
        frames = {1},
        texture = 'entity_thoughts',
    },

    ['think'] = {
        frames = {11,12,13,14},
        texture = 'entity_thoughts',
        interval = 0.3
    },
    ['calling'] = {
        frames = {2,3,4},
        texture = 'entity_thoughts',
        interval = 0.3
    },    
    ['sing'] = {
        frames = {5,6,7,8,9,10},
        texture = 'entity_thoughts',
        interval = 0.3
    },

}