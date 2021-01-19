

--libraries
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--Important Utilities
require 'src/Animation'
require 'src/Constants'
require 'src/Util'
require 'src/StateMachine'
require 'src/states/StateStack'

--State's
require 'src/states/BaseState'
require 'src/states/Game/PlayState'
require 'src/states/Game/HouseState'
require 'src/states/Game/TitleScreenState'
require 'src/states/Game/LoseState'
require 'src/states/Game/PauseState'
require 'src/states/Game/CashInMoneyState'
require 'src/states/Game/DialogueState'
require 'src/states/Game/FadeState'

--animations/dialogue's
require 'src/states/Game/animationStates/OpeningDialogue'
require 'src/states/Game/animationStates/HighCrimeRateDialogue'
require 'src/states/Game/animationStates/DeveloperCommentsDiologue'

--gui
require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

--Classes
require 'src/Object'
require 'src/world/Tile'
require 'src/world/tile_ids'
require 'src/world/Tile_map'
require 'src/TutorialManager'
require 'src/BrickwallBackground'

--Classes that make the house
require 'src/House/HouseMaker'
require 'src/House/SolidObjectsMaker'
--Defs
require 'src/House/game_object_defs'
require 'src/House/house_defs'

--player Classes
require 'src/entity/Entity'
require 'src/entity/Player'
require 'src/entity/PersonAi'
require 'src/entity/PoliceAi'

require 'src/states/entity/playerCharacter/PlayerWalkState'
require 'src/states/entity/playerCharacter/PlayerIdleState'

--Enemy behaviours
require 'src/states/entity/enemyAi/personAi/PersonAiIdleState'
require 'src/states/entity/enemyAi/personAi/PersonAiFleeingState'

require 'src/states/entity/enemyAi/policeAi/PoliceAiSearchingState'

require 'src/states/entity/enemyAi/MoveAction'
require 'src/states/entity/enemyAi/ChangeDirectionAction'
require 'src/states/entity/enemyAi/ActionSetFinnished'
require 'src/states/entity/enemyAi/ActionSetStart'
require 'src/states/entity/enemyAi/MultiAction'

require 'src/entity/entity_defs'

gTextures = {
    ['house_For_Testing'] = love.graphics.newImage('graphics/TileSets_House/HouseTest.png'),
    ['pink_Tiled_House1'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet1.png'),
    ['red-brown_House2'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet2.png'),
    ['log_Cabin_House3'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet3.png'),
    ['beige_house4'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet4.png'),
    ['egyptian_house5'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet5.png'),
    ['ocean_house6'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet6.png'),
    ['brown_tiled_house7'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet7.png'),
    ['mysterious_blue_house8'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet8.png'),
    ['white_house9'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet9.png'),
    ['yellow_house10'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet10.png'),
    ['blue_tiled_house11'] = love.graphics.newImage('graphics/TileSets_House/House_TileSet11.png'),
    ['Furniture'] = love.graphics.newImage('graphics/Furniture/Objects_TileSet1.png'),

    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),

    --player graphics
    ['character_run'] = love.graphics.newImage('graphics/Characters/Character_Run1.png'),
    ['character_idle'] = love.graphics.newImage('graphics/Characters/Character_Idle1.png'),

    ['Roki_run'] = love.graphics.newImage('graphics/Characters/Roki_run.png'),
    ['Roki_idle'] = love.graphics.newImage('graphics/Characters/Roki_idle.png'),

    ['Dan_run'] = love.graphics.newImage('graphics/Characters/Dan_run.png'),
    ['Dan_idle'] = love.graphics.newImage('graphics/Characters/Dan_idle.png'),

    ['HalloweenKid_run'] = love.graphics.newImage('graphics/Characters/HalloweenKid_run.png'),
    ['HalloweenKid_idle'] = love.graphics.newImage('graphics/Characters/HalloweenKid_idle.png'),

    ['Molly_run'] = love.graphics.newImage('graphics/Characters/Molly_run.png'),
    ['Molly_idle'] = love.graphics.newImage('graphics/Characters/Molly_idle.png'),

    ['Rob_run'] = love.graphics.newImage('graphics/Characters/Rob_run.png'),
    ['Rob_idle'] = love.graphics.newImage('graphics/Characters/Rob_idle.png'),

    ['Police_run'] = love.graphics.newImage('graphics/Characters/Police_run.png'),
    ['Police_idle'] = love.graphics.newImage('graphics/Characters/Police_idle.png'),
    ['Police_Shoot'] = love.graphics.newImage('graphics/Characters/Police_Caught.png'),

    ['entity_thoughts'] = love.graphics.newImage('graphics/Characters/Entity_Thoughts 160w x 32h.png'),

    ['grassTile'] = love.graphics.newImage('graphics/grass.png'),

    --big sprites
    ['bigSprites'] = love.graphics.newImage('graphics/bigSprites1.png'),

    --background
    ['notePad'] = love.graphics.newImage('graphics/notePad.png'),
    ['brick_wall'] = love.graphics.newImage('graphics/brick_background.png'),
    ['playerUi'] = love.graphics.newImage('graphics/PlayerUi.png'),
}

gFrames = {
    --All house textures are structured exactly the same, hence why we only have one house frame
    ['House'] = GenerateQuads(gTextures['house_For_Testing'], 16, 16),
    ['Furniture'] = GenerateQuads(gTextures['Furniture'], 16, 16),
    ['character_run'] = GenerateQuads(gTextures['character_idle'], 16, 16),
    ['character_idle'] = GenerateQuads(gTextures['character_run'], 16, 16),

    ['Roki_run'] = GenerateQuads(gTextures['Roki_run'], 16, 16),
    ['Roki_idle'] = GenerateQuads(gTextures['Roki_idle'], 16, 16),

    ['Dan_run'] = GenerateQuads(gTextures['Dan_run'], 16, 16),
    ['Dan_idle'] = GenerateQuads(gTextures['Dan_idle'], 16, 16),
    ['HalloweenKid_run'] = GenerateQuads(gTextures['HalloweenKid_run'], 16, 16),
    ['HalloweenKid_idle'] = GenerateQuads(gTextures['HalloweenKid_idle'], 16, 16),
    ['Molly_run'] = GenerateQuads(gTextures['Molly_run'], 16, 16),
    ['Molly_idle'] = GenerateQuads(gTextures['Molly_idle'], 16, 16),

    ['Rob_run'] = GenerateQuads(gTextures['Rob_run'], 16, 16),
    ['Rob_idle'] = GenerateQuads(gTextures['Rob_idle'], 16, 16),

    ['Police_run'] = GenerateQuads(gTextures['Police_run'], 16, 16),
    ['Police_idle'] = GenerateQuads(gTextures['Police_idle'], 16, 16),
    ['Police_Shoot'] = GenerateQuads(gTextures['Police_Shoot'], 16, 16),

    ['entity_thoughts'] = GenerateQuads(gTextures['entity_thoughts'], 16, 16),

    ['bigSprites'] = GenerateQuads(gTextures['bigSprites'], 37, 46),
}

gFonts = {
    ['regular-small'] = love.graphics.newFont('fonts/Silkscreen_Font/Silkscreen_normal.ttf', 8),
    ['regular-medium'] = love.graphics.newFont('fonts/Silkscreen_Font/Silkscreen_bold.ttf', 8),
    ['regular-large'] = love.graphics.newFont('fonts/Silkscreen_Font/Silkscreen_bold.ttf', 24),
    ['regular-huge'] = love.graphics.newFont('fonts/Silkscreen_Font/Silkscreen_normal.ttf', 56),

    ['extra-small'] = love.graphics.newFont('fonts/uni0553_Font/uni0553-webfont.ttf', 8),

    ['arcade-small'] = love.graphics.newFont('fonts/fipps/fipps.otf', 24),

    ['gothic'] = love.graphics.newFont('fonts/zelda/GothicPixels.ttf',24)
    --['arcade-small'] = love.graphics.newFont('fonts/arcade_alternate/ArcadeAlternate.ttf', 24),
}

gSounds = {
    ['test'] = love.audio.newSource('sounds/test.wav'),
    ['test1'] = love.audio.newSource('sounds/test1.wav'),
    ['blip'] = love.audio.newSource('sounds/blip.wav'),

    --sounds effects
    ['jail_door_open'] = love.audio.newSource('sounds/soundEffects/prisonDoorOpen.wav'),
    ['select1'] = love.audio.newSource('sounds/soundEffects/selectSound1.wav'),
    ['select2'] = love.audio.newSource('sounds/soundEffects/selectSound2.wav'),
    ['helicopter'] = love.audio.newSource('sounds/soundEffects/distantHelicopterNoises.wav'),
    ['distant_sirens'] = love.audio.newSource('sounds/soundEffects/distantSirenNoises.wav'),
    ['fbiOpenUp'] = love.audio.newSource('sounds/soundEffects/fbiOpenUp.mp3'),

    ['gasp1'] = love.audio.newSource('sounds/soundEffects/gasp1.wav'),
    ['gasp2'] = love.audio.newSource('sounds/soundEffects/gasp2.wav'),
    ['panicked_talking'] = love.audio.newSource('sounds/soundEffects/gasp3_panick.wav'),

    ['footSteps'] = love.audio.newSource('sounds/soundEffects/footSteps.wav'),
    ['loseSound'] = love.audio.newSource('sounds/soundEffects/loseSound.wav'),
    ['swipe'] = love.audio.newSource('sounds/soundEffects/swipe.wav'),
    ['break'] = love.audio.newSource('sounds/soundEffects/break.wav'),
    ['cash'] = love.audio.newSource('sounds/soundEffects/cash.mp3'),

    ['metal_door_opening'] = love.audio.newSource('sounds/soundEffects/metalDoorOpening.wav'),
    ['metal_door_closing'] = love.audio.newSource('sounds/soundEffects/metalDoorClosing.wav'),

    --talking sounds
    ['anonymous_talking'] = love.audio.newSource('sounds/soundEffects/sanstTalking2.mp3'),
    ['radioHost_talking'] = love.audio.newSource('sounds/soundEffects/highpitchTalking.wav'),
    ['radio'] = love.audio.newSource('sounds/soundEffects/transmit.wav'),

    --music
    ['music_calm'] = love.audio.newSource('sounds/music/calm.mp3'),
    ['music_intense'] = love.audio.newSource('sounds/music/intense.mp3'),
    ['music_intro_intense'] = love.audio.newSource('sounds/music/intenseWithGlissando.mp3'),
}