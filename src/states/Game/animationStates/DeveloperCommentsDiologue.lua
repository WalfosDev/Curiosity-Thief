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
DeveloperCommentsDiologue = Class{__includes = BaseState}

--Dialogue is not made with dialogue class because it has so many menu's.
function DeveloperCommentsDiologue:init(player)
	gSounds['music_calm']:stop()
	self.player = player

	self.background = BrickwallBackground()

	self.blackScreenOpacity = 0
	self.characterOpacity = 0

	self.numberOfTimesEntered = 0

	--changes character to my character
	self.character = 4

	Timer.after(0.5, function()
		--screen becomes darker
		Timer.tween(1, {
	        [self] = {blackScreenOpacity = 100, characterOpacity = 255}
	    }):finish(function()

	    	--dialogue appears
	    	gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		    "Hey I'm Merrick! A 15 year old student. For the past couple of months I have been doing cs50g."))
	    end)--end of tween function	
	end)--end of timer function

end

function DeveloperCommentsDiologue:enter()
	--everytime it is entered this value increases which makes a new diologue play
	self.numberOfTimesEntered = self.numberOfTimesEntered + 1

	if self.numberOfTimesEntered == 2 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		"Now after all the course work I was finally able to make this game."))

	elseif self.numberOfTimesEntered == 3 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		"I proudly present to you my cs50 final project submission. Curiosity Thief!"))

	elseif self.numberOfTimesEntered == 4 then
		--dialogue appears
	    gStateStack:push(DialogueState(self.player, false,  'radioHost_talking',
		"I hope you enjoy the game!"))

	elseif self.numberOfTimesEntered == 5 then
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

function DeveloperCommentsDiologue:update(dt)
	if self.menu then
		self.menu:update(dt)
	end

end

function DeveloperCommentsDiologue:render()
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

