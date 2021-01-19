--Used in the entity statestack to change the entities direction

ChangeDirectionAction = Class{__includes = BaseState}

function ChangeDirectionAction:init(character, direction)
	self.character = character
	self.direction = direction

	if direction == 'random' then
		local randomizer = math.random(1,4)
		if randomizer == 1 then
			self.direction = 'right'
		elseif randomizer == 2 then
			self.direction = 'left'
		elseif randomizer == 3 then
			self.direction = 'up'
		elseif randomizer == 4 then
			self.direction = 'down'
		end
	end

end

function ChangeDirectionAction:enter()
	self.character.direction = self.direction
	self.character:changeAnimation('idle-' .. self.character.direction)

	self.character.stateStack:pop()
end

function ChangeDirectionAction:update(dt)

end

function ChangeDirectionAction:render()

end

