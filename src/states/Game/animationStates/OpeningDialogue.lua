--[[
There are 3 dialogues in the game that function very similarly. Actual dialogue is done with the diologueState. 
These states constantly keep pushing new dialogue until the dialogue is completed and makes background. Example:  

HighCrimeRateDiologue state first initializes a background and renders a big version of the character talking on the screen, 
then it pushes the DiologueState with some dialogue, which then pops. When the stateStack re-enters this state a variable, 
numberOfTimesEntered increases by 1, and based on the value of this variable another dialogue is pushed until eventually it 
reaches a number that causes the state to be exited. 

Overview of what each dialogue is about: 
(a)DeveloperCommentsDiologue - gives some developers remarks on the game, can be activated by pressing developer comments 
in the TitleScreenState 
(B)HighCrimeRateDiologue - A cool dialogue that indicates to the player their crime rate is high, activates when the crime rate 
is over the max crime rate 
(C)OpeningDialogue - This is the dialogue activated on play, it gives an overview of the game as well as asking the player some 
preference questions (tutorial, controls) using the menu GUI. Then it feeds this information into the playState. 

]]
OpeningDialogue = Class{__includes = BaseState}

function OpeningDialogue:init()
	gSounds['music_calm']:stop()
	self.background = BrickwallBackground()

	self.blackScreenOpacity = 0
	self.characterOpacity = 0

	self.numberOfTimesEntered = 0
end

function OpeningDialogue:enter()
	--everytime it is entered this value increases which makes a new diologue play
	self.numberOfTimesEntered = self.numberOfTimesEntered + 1

	if self.numberOfTimesEntered == 1 then
		Timer.after(0.5, function()
			--screen becomes darker
			Timer.tween(1, {
		        [self] = {blackScreenOpacity = 100, characterOpacity = 255}
		    }):finish(function()

		    	--dialogue appears
		    	gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
			    "Pssst, over here."))

		    end)--end of tween function	
		end)--end of timer function

	elseif self.numberOfTimesEntered == 2 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"I heard that you were one of the best thieves in the world before you were imprisoned."))

	elseif self.numberOfTimesEntered == 3 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false, 'anonymous_talking',
		"..."))

	elseif self.numberOfTimesEntered == 4 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"Look lets make a deal, I'll free you. But I need you to go steal a bunch of stuff from houses and sell them to me."))

	elseif self.numberOfTimesEntered == 5 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"Every few houses i'll give you a chance to sell me the goods, or you can continue to get a mutiplier on sales."))

	elseif self.numberOfTimesEntered == 6 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"Alright so your main objective is to steal things and sell them to increase your score, and to evade police. Understand?"))

	elseif self.numberOfTimesEntered == 7 then
		self.menu = Menu {
    		player = self.player,
            x = 0,
            y = 80,
            width = VIRTUAL_WIDTH,
            height = 48,
            items = {
                {
                    text = 'Yes',
                    onSelect = function()
                    	self.menu = nil
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"Phew pretty good considering all the years you've been in jail. But..."))
                    end
                },
                {
                    text = 'No',
                    onSelect = function()
                    	self.menu = nil
                    	self.numberOfTimesEntered = 3
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"Okayyy I'll explain again."))
                    end
                }
            }
        }

	elseif self.numberOfTimesEntered == 8 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"You look a little lost. Do you need a tutorial to refresh your memory?"))

	elseif self.numberOfTimesEntered == 9 then
	    self.menu = Menu {
    		player = self.player,
            x = 0,
            y = 80,
            width = VIRTUAL_WIDTH,
            height = 48,
            items = {
                {
                    text = 'Full Tutorial',
                    onSelect = function()
                    	self.menu = nil
						self.enableTutorial = true
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"First thing is first to skip dialogue just press enter. I'll tell you the rest on the radio as you go through the house."))
                    end
                },
                {
                    text = 'Quick Tutorial',
                    onSelect = function()
                    	self.menu = nil
						self.enableTutorial = "quickTutorial"
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"First thing is first to skip dialogue just press enter. I'll tell you the rest on the radio as you go through the house."))
                    end
                },
                {
                    text = 'No thanks',
                    onSelect = function()
                    	self.menu = nil
                    	self.enableTutorial = false
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"Alright man, but don't mess up"))
                    end
                }
            }
        }

	elseif self.numberOfTimesEntered == 10 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"Last question before we close the deal. Which controls do you normally use?"))
	elseif self.numberOfTimesEntered == 11 then
		self.menu = Menu {
    		player = self.player,
            x = 0,
            y = 80,
            width = VIRTUAL_WIDTH,
            height = 48,
            items = {
                {
                    text = 'W A S D',
                    onSelect = function()
                    	self.menu = nil
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"Yeah the best thieves use that system hehehe."))
                    end
                },
                {
                    text = 'Arrow Keys',
                    onSelect = function()
                    	self.menu = nil
                    	moveUp = 'up'
						moveDown = 'down'
						moveRight = 'right'
						moveLeft = 'left'
                        --dialogue appears
					    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
						"Use arrow keys to navigate the menu and stuff from now on."))
                    end
                }
            }
        }

	elseif self.numberOfTimesEntered == 12 then
		gSounds['jail_door_open']:play()
		self.background:exit()
		gStateStack:push(FadeState("black", 1, "in", function()
			gStateStack:pop() --pops dialogue
			gStateStack:push(FadeState("black", 1, "out", function()
				gStateStack:push(PlayState(self.enableTutorial))
			end))--end of second fade state function
		end))--end of first fade state function

	end

end

function OpeningDialogue:update(dt)
	if self.menu then
		self.menu:update(dt)
	end

end

function OpeningDialogue:render()
	love.graphics.setColor(255,255,255,255)
	
	self.background:render()

	love.graphics.setColor(0,0,0, self.blackScreenOpacity)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

	love.graphics.setColor(255,255,255, self.characterOpacity)
	--draws ominous character to the screen
	love.graphics.draw(gTextures['bigSprites'], 
    gFrames['bigSprites'][1],
    math.floor(164), 
    math.floor(20) --10 px offset on the y cause the has some blank space of 10px
    )

    if self.menu then
		self.menu:render()
	end

	love.graphics.setColor(255,255,255,255)
	--love.graphics.printf('x:' .. tostring(self.x)..'y:' .. tostring(self.y), 50, self.y, self.x, 'center')
end

