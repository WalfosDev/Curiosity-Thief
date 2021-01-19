--[[
The Lose state is pushed onto the stack when the PoliceAi comes in a 1 tile radius of the player. 
The lose state fades the screen to black and shows your score as well as having a little dialogue. 
You can choose to leave the game or restart, when you restart it pops all the states including the 
playstate and then pushes a new playstate re-initializing the player essentially. 
]]

LoseState = Class{__includes = BaseState}

function LoseState:init(player)
	gSounds['music_calm']:stop()
	gSounds['music_intense']:setVolume(0.4)
	gSounds['metal_door_opening']:play()
	gSounds['loseSound']:play()
	
	self.player = player

	--makes a charcater and black background fade in
	self.characterOpacity = 0
	self.opaquenessOfBackground = 0
	Timer.tween(1, {
		[self] = {opaquenessOfBackground = 180, characterOpacity = 255}
	})
	--keeps track of what character is being displayed
	self.character = 1

	self.selectedButton = 0
	self.canPressButtons = false --does not allow player to change selection since diologue is playing

	--keeps track of how many times the state was enetered for diologue to work
	self.numberOfTimesEntered = 0

	--makes the character speak after 0.5 seconds, beggining the diologue
	Timer.after(0.5, function()
		self.character = 2 --makes the rwadio character appear
		gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
        "O dear, it looks like it is to late to free you.",
        function()
            gSounds['radio']:play()
        end))
	end)

end

function LoseState:enter()
	--everytime it is entered this value increases which makes a new diologue play
	self.numberOfTimesEntered = self.numberOfTimesEntered + 1
	if self.numberOfTimesEntered == 1 then
		self.character = 2
		gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
        "Don't worry I will come to the jail and free you if you play again",
        function()
            gSounds['radio']:play()
        end))

	elseif self.numberOfTimesEntered == 2 then
		self.character = 3 --makes police character show up
		self.canPressButtons = true --player can now choose if they want to quite the state
		gSounds['metal_door_closing']:play()
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false, 'anonymous_talking',
		"HANDS UP! Your going back to jail."))
	end

end

function LoseState:update(dt)
	if self.canPressButtons then
		--when enter is pressed it goes to the current selected option
		if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
			--if its play again all states are popped up to the playState
			if self.selectedButton == 0 then
				gSounds['music_intense']:setVolume(1)
				gStateStack:pop()
				gStateStack:pop()
				gStateStack:pop()
				gStateStack:push(PlayState())
			--if it is quit then the game is quitted
			elseif self.selectedButton == 1 then
				love.event.quit()
			end
		--changes selection
		elseif love.keyboard.wasPressed(moveUp) or love.keyboard.wasPressed(moveDown) then
			self.selectedButton = self.selectedButton + 1
			if self.selectedButton == 2 then
				self.selectedButton = 0
			end
		end
	end

end

function LoseState:render()
	love.graphics.setColor(255,255,255,255)
	love.graphics.translate(math.floor(self.player.cameraScrollx), math.floor(self.player.cameraScrolly))

	--black background
	love.graphics.setColor(0,0,0,self.opaquenessOfBackground)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

	--orange colour
	love.graphics.setColor(255,162,0,255)

	love.graphics.setFont(gFonts['gothic'])
	love.graphics.printf('You lose!', 20, 0, 400, 'left')
	--stats
	love.graphics.setFont(gFonts['regular-medium'])
	love.graphics.printf('Total Houses Robbed: ', 5, 30, 200, 'left')
	love.graphics.printf('Current  Items Stolen: ', 5, 40, 200, 'left')
	love.graphics.printf('Total Items Stolen: ', 5, 50, 200, 'left')
	love.graphics.printf('Total Ammount Of $: ', 5, 60, 200, 'left')
	love.graphics.printf(tostring(self.player.numberOfHousesRobbed), 150, 30, 200, 'left')
	love.graphics.printf(tostring(#self.player.stolenObjects), 150, 40, 200, 'left')
	love.graphics.printf(tostring(self.player.totalStolenObjects), 150, 50, 200, 'left')
	love.graphics.printf(tostring(self.player.moneyAmmount), 150, 60, 200, 'left')

	--Play button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 0 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Play Again', 50, 80, 110, 'center')
	--Quit button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 1 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Quit', 50, 100, 110, 'center')

	love.graphics.setColor(255,255,255, self.characterOpacity)
	--draws ominous character to the screen
	love.graphics.draw(gTextures['bigSprites'], 
    gFrames['bigSprites'][self.character],
    math.floor(168), 
    math.floor(30) --10 px offset on the y cause the has some blank space of 10px
    )

	love.graphics.setColor(255,255,255,255)
end

