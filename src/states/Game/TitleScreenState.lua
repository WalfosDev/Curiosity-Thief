--[[
This state is the titleScreen. 

It has the brickWallBakckground. And some options to go in the game or see the developers comments.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
	gSounds['music_calm']:play()
	gSounds['music_calm']:setVolume(0.5)

	self.selectedButton = 0

	self.background = BrickwallBackground(true)
end

function TitleScreenState:enter()
	gSounds['music_calm']:play()
	gSounds['music_calm']:setVolume(0.5)

	self.selectedButton = 0
end

function TitleScreenState:update(dt)
	--when enter is pressed it goes to the current selected option
	if  love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter')  then 
		gSounds['music_calm']:stop()
		gSounds['jail_door_open']:play()
		self.background:exit()

		--if the play button was selected it starts the opneing diologue
		if self.selectedButton == 0 then
			gStateStack:push(FadeState("black", 1, "in", function()
				gStateStack:pop()
				gStateStack:push(OpeningDialogue())
				gStateStack:push(FadeState("black", 1, "out", function() end))
			end))

		--if the quite button was selected it quits the game
		elseif self.selectedButton == 1 then
			gStateStack:push(FadeState("black", 1, "in", function()
				love.event.quit()
			end))

		--if the developer comments button was selected it goes to developer comments
		elseif self.selectedButton == 2 then
			gStateStack:push(FadeState("black", 1, "in", function()
				gStateStack:push(DeveloperCommentsDiologue())
				gStateStack:push(FadeState("black", 1, "out", function() end))
			end))
		end
	
	--when w or s are pressed it chages selection
	elseif love.keyboard.wasPressed('w') then
		gSounds['select2']:play()
		self.selectedButton = self.selectedButton - 1
		--if selection goes past the minmum selection button goes to the maximum selection button
		if self.selectedButton == -1 then
			self.selectedButton = 2
		end
	elseif love.keyboard.wasPressed('s') then
		gSounds['select2']:play()
		--if selection goes past the maximum selection button goes to the minmum selection button
		self.selectedButton = self.selectedButton + 1
		if self.selectedButton == 3 then
			self.selectedButton = 0
		end
	end

end

function TitleScreenState:render()
	love.graphics.setColor(255,255,255,255)
	self.background:render()

	love.graphics.setFont(gFonts['regular-large'])
	--Play button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 0 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Play', 50, 20, 110, 'center')
	--Quit button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 1 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Quit', 50, 49, 110, 'center')

	love.graphics.setFont(gFonts['regular-medium'])
	--developer comments button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 2 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Developer Comments', 0, 80, 200, 'center')

	--comments at the bottom of the screen
	love.graphics.setColor(145,145,145,255)
	love.graphics.setFont(gFonts['extra-small'])
	love.graphics.printf("By default press w and s to change selection.", 0, 110, 200, 'left')
	love.graphics.printf("Press enter to continue as well as skip text.", 0, 118, 200, 'left')
end

