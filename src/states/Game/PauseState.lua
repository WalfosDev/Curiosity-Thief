--[[
When P is pressed the pauseState is pushed onto the stack. From there you can exit the game or resume. 
The pauseState shows the players money, total objects stolen, houses robbed and the current number of objects stolen. 
The background is taken from the brickBackGround Class. When resume is pressed this state is popped and the playState is re-entered.
]]

PauseState = Class{__includes = BaseState}

function PauseState:init(player)
	gSounds['music_calm']:pause()
	gSounds['music_intense']:pause()
	gSounds['metal_door_opening']:play()

	self.background = BrickwallBackground(true)

	self.player = player

	--makes the pauseState come from above by tweening the position of everythings y
	self.stateYOffset = -VIRTUAL_HEIGHT
	Timer.tween(1, {
        [self] = {stateYOffset = 0}
    }):finish(function()

    end)

	self.selectedButton = 0
end

function PauseState:update(dt)
	--when enter is pressed it goes to the current selected option
	if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then --when space is pressed a new house genrates
		self.background:exit()
		gSounds['metal_door_closing']:play()

		--if the button selected was resume then the game resume
		if self.selectedButton == 0 then
			--tweens the pause state back to the top
			Timer.tween(1, {
		        [self] = {stateYOffset = -VIRTUAL_HEIGHT}
		    }):finish(function()
		    	gStateStack:pop()
		    end)
		--if the button selected was quit then the game quits
		elseif self.selectedButton == 1 then
			love.event.quit()
		end
	end

	--changes selection
	if love.keyboard.wasPressed(moveUp) or love.keyboard.wasPressed(moveDown) then
		gSounds['select2']:play()
		self.selectedButton = self.selectedButton + 1
		if self.selectedButton == 2 then
			self.selectedButton = 0
		end
	end

end

function PauseState:render()
	love.graphics.translate(math.floor(self.player.cameraScrollx), math.floor(self.stateYOffset+self.player.cameraScrolly))

	self.background:render()

	love.graphics.setFont(gFonts['regular-medium'])
	--Play button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 0 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Resume', 0, 5, 200, 'center')
	--Quit button
	love.graphics.setColor(255,0,0,255)
	if self.selectedButton == 1 then
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.printf('Quit', 0, 15, 200, 'center')

	--displays stats
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf('Total Houses Robbed: ', 5, 30, 200, 'left')
	love.graphics.printf('Current  Items Stolen: ', 5, 40, 200, 'left')
	love.graphics.printf('Total Items Stolen: ', 5, 50, 200, 'left')
	love.graphics.printf('Total Ammount Of $: ', 5, 60, 200, 'left')
	love.graphics.printf(tostring(self.player.numberOfHousesRobbed), 150, 30, 200, 'left')
	love.graphics.printf(tostring(#self.player.stolenObjects), 150, 40, 200, 'left')
	love.graphics.printf(tostring(self.player.totalStolenObjects), 150, 50, 200, 'left')
	love.graphics.printf(tostring(self.player.moneyAmmount), 150, 60, 200, 'left')
end

