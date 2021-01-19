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
HighCrimeRateDialogue = Class{__includes = BaseState}

--Dialogue is not made with dialogue class because it has so many menu's.
function HighCrimeRateDialogue:init(player)
    gSounds['music_intense']:setVolume(0.2)
    gSounds['music_calm']:setVolume(0.5)

	self.player = player

	self.background = BrickwallBackground()

	self.blackScreenOpacity = 0
	self.characterOpacity = 0

	self.numberOfTimesEntered = 0

	--renders the ominous character onto the screen
	self.character = 1 
end

function HighCrimeRateDialogue:enter()
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
			    "What are you doing man! Your all over the news! Here look."))

		    end)--end of tween function	
		end)--end of timer function

	elseif self.numberOfTimesEntered == 2 then
		--changes character to radio
		self.character = 2
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		"Breaking news, a wanted criminal just escaped from prison and is going on a rampage robbing all houses in sight."))

	elseif self.numberOfTimesEntered == 3 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false, 'radioHost_talking',
		"So far the criminal has robbed "..tostring(self.player.numberOfHousesRobbed).." houses. Please lock your doors and be carefull."))

	elseif self.numberOfTimesEntered == 4 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		"The swat team is currently following them do not be alarmed."))

	elseif self.numberOfTimesEntered == 5 then
		--changes character back to ominous character
		self.character = 1
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"O_o I told you to stay down low."))

	elseif self.numberOfTimesEntered == 6 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
		"Uggh just go continue getting my stuff, see you soon."))

	elseif self.numberOfTimesEntered == 7 then
		gSounds['music_intense']:setVolume(1)
    	gSounds['music_calm']:setVolume(0.5)
		gSounds['jail_door_open']:play()
		self.background:exit()
		gStateStack:push(FadeState("black", 1, "in", function()
			gStateStack:pop() --pops dialogue
			gStateStack:push(FadeState("black", 1, "out", function() end))--end of second fade state function
		end))--end of first fade state function

	end

end

function HighCrimeRateDialogue:update(dt)
	if self.menu then
		self.menu:update(dt)
	end

end

function HighCrimeRateDialogue:render()
	love.graphics.setColor(255,255,255,255)
	
	self.background:render()

	love.graphics.setColor(0,0,0, self.blackScreenOpacity)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

	love.graphics.setColor(255,255,255, self.characterOpacity)
	--draws ominous character to the screen
	love.graphics.draw(gTextures['bigSprites'], 
    gFrames['bigSprites'][self.character],
    math.floor(164), 
    math.floor(20) --10 px offset on the y cause the has some blank space of 10px
    )

    if self.menu then
		self.menu:render()
	end

	love.graphics.setColor(255,255,255,255)
end

