--[[
This state displays all the items the player has stolen and their value, which it gets from the player's itemsRobbedTable. 
The player can press w & s to scroll through all items. The state then totals it up at the bottom. If there is a multiplier 
when enter is pressed this multiplier is added onto all values of the stolen objects. Finally, when enter is pressed again 
this total value of all the objects is added to the total money the player has. 

To make the scroll happen the list just renders 6 values, from the current item in the list being looked at.
This value increases/decreases when w or s is pressed.
]]

CashInMoneyState = Class{__includes = BaseState}

function CashInMoneyState:init(player)
	self.player = player

	--picks how many stolen items display in the list
	if #self.player.stolenObjects > 5 then --if its more than 5 then 6 items render
		self.numberOfObjectsThatDisplayInList = 6
	else --else its how many items that were stolen that render
		self.numberOfObjectsThatDisplayInList = #self.player.stolenObjects
	end
	--the starting number of displaying items in the list.
	self.countStartingNum = 0

	--Totals up the value of all objects
	self.totalMoneyAmount = 0
	local count = 0
	for i = 1, #self.player.stolenObjects do
		count = count + 1
		local object = self.player.stolenObjects[count]
		self.totalMoneyAmount = self.totalMoneyAmount + object.objectsWorth
	end

	--There are 2 states in this, before and after the multiplier is added.
	--state = 1 is before the multiplier is added when enter is pressed the multiplier is added and it briefly shows on screen.
	--state = 2 is after the mul;tiplier is added and when enter is pressed the state pops itself.
	self.state = 0
	self.alphaForMultiplier = 0

	Timer.after(0.5, function()
		self.player:updateTutorial('cashInMoneyState',self)
	end)

end

function CashInMoneyState:enter()
	self.player:updateTutorial('cashInMoneyState',self)
end

function CashInMoneyState:update(dt)
	--allows the player to sort through all the items they stole by increasing the current number being viewed
	--however it clamps so that the player can't go past all their items into and cause an error
	if love.keyboard.wasPressed(moveUp) then
		self.countStartingNum = math.min(self.countStartingNum + 1,#self.player.stolenObjects-self.numberOfObjectsThatDisplayInList)
	elseif love.keyboard.wasPressed(moveDown) then
		self.countStartingNum = math.max(self.countStartingNum - 1, 0)


	elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
		self.state = self.state + 1
		--the first time enter is pressed it adds the mutliplier
		if self.state == 1 then
			gSounds['cash']:play()
			--makes the multiplier number quickly fade in and out
			Timer.tween(0.5, {
				[self] = {alphaForMultiplier = 255}
			}):finish(function()
			Timer.tween(0.25, {
				[self] = {alphaForMultiplier = 0}
			})
			end)
			--for all the items it adds the multiplier and re-totals them
			local count = 0
			for i = 1, #self.player.stolenObjects do
				count = count + 1
				local object = self.player.stolenObjects[count]
				object.objectsWorth = object.objectsWorth * self.player.cashInMoneyMultiplier
			end
			self.totalMoneyAmount = self.totalMoneyAmount * self.player.cashInMoneyMultiplier

		--the second timer enter is pressed it leaves the state and adds the money to the player
		else
			self.player.moneyAmmount = self.player.moneyAmmount + self.totalMoneyAmount
			self.player.stolenObjects = {}
			gStateStack:pop()
			gStateStack:push(HouseState(self.player))
		end
	end

end

function CashInMoneyState:render()
	love.graphics.setFont(gFonts['extra-small'])
	love.graphics.setColor(255,255,255,255)
	
	---makes blackbackground
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

	love.graphics.setColor(255,255,255,255)
	--renders notePad
	love.graphics.draw(gTextures['notePad'], 0, 0)

	--renders black text on notepaad shpowing items
	love.graphics.setColor(0,0,0,255)
	--renders the itmes from the list of stolen items, but not all at once so it doesn't go off the screen.
	local count = self.countStartingNum
	for i = 0,self.numberOfObjectsThatDisplayInList-1 do
		count = count + 1
		local object = self.player.stolenObjects[count]
		love.graphics.printf(tostring(count), 44, 25+(12*i), 10, 'left')
		love.graphics.printf(tostring(object.name), 55, 25+(12*i), 150, 'left')
		love.graphics.printf("$"..tostring(object.objectsWorth), 115, 25+(12*i), 150, 'left')
	end
	--text that shows the total of all the items
	love.graphics.printf("Total:    "..tostring(self.totalMoneyAmount), 80, 109, 150, 'left')
	love.graphics.printf(tostring(#self.player.stolenObjects), 44, 109, 150, 'left')

	--renders multiplier
	love.graphics.setFont(gFonts['regular-huge'])
	love.graphics.setColor(255,255,255,self.alphaForMultiplier)
	love.graphics.printf("X "..tostring(self.player.cashInMoneyMultiplier), 10, 25, 250, 'left')
end

