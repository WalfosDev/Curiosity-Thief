--Used in the entity statestack to commence the stack

ActionSetStart = Class{__includes = BaseState}

function ActionSetStart:init(character)  
	character.stateStack:pop()
end

function ActionSetStart:update(dt)
	
end

function ActionSetStart:render()

end

