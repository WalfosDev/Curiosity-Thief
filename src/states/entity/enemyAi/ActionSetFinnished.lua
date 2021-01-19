--Used in the entity statestack to tell the game that all of this stacks actions are finnished so this should be placed at the bottom of the stack

ActionSetFinnished = Class{__includes = BaseState}

function ActionSetFinnished:init(character)
	self.character = character
	
end

function ActionSetFinnished:enter()
	self.character:changeAnimation('idle-' .. self.character.direction)
	self.character.actionSetComplete = true

	if self.character.type == "police" then
		if self.character.isPlayerGhosting then
			self.character.playerGhostComplete = true
		end
	end
end

function ActionSetFinnished:update(dt)
	
end

function ActionSetFinnished:render()

end

