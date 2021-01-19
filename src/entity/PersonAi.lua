--[[
This ai inherits from entity and it's states can be found in states.entity/enemyAI/personAi

This is an ai that spawns when the house is initialised and is found in random locations in the house and are the 
inhabitants of the houses. They can be seen walking in random directions in the house while doing something 
(such as thinking, talking on the phone) which are represented by thought bubbles by the entity's head, 
this is all in the PersonAidleState. If the entity see’s the player ie: the player is in the entities view then
the AI switches to the PersonAiFleengState which makes the entity appear to panic, sometimes pacing back and forth really fast, 
at the same time their thought bubble switches to an exclamation mark. The player's crime rate increases any time this happens 
(the entity see’s the player). So basically, the player needs to avoid being seen by this ai. 

To have these thought bubbles the personAi has a renderThought() function and changeThoughtAnimation() function so that 
when the personAi renders so does the thoughtAnimation, which comes from an Entity_Thought sprite sheet. 

The PersonAidleState just picks a random action to do: standStill or randomlyWalk, based on this it chooses an appropriate 
thought animation and calls the correct actions onto the AI’s stateStack. Whenever the action set is indicated as complete 
by the actionSetComplete variable then this process is repeated. Alongside this the states update function always calls the 
isEnityInView(player) function on the ai it’s managing, if it returns true for seeing the player then the stateMachine switches 
to the PersonAiFleeingState. 

The fleeingState; clears all actions off of the stack, changes the entities thought to an alarmed expression, and increases the 
players crime rate. After that the entity stays still for 2 seconds before choosing whether it should continue to stay still or 
do a pacing up and down movement. If it does a pacing up and down movement the ai’s speed increases and some actions are added 
onto the stateStack to make the ai pace up and down. 
]]
PersonAi = Class{__includes = Entity}


function PersonAi:init()
    self.actionSetComplete = false
end

function PersonAi:initialiseCharacter(def)
	Entity.init(self, def)

    --gets the thoughgt animations
	self.thoughtAnimations = self:createAnimations(NPC_THOUGHT_ANIMATIONS)
	self.currentThought = false
	self:changeThoughtAnimation('nothing')
end

function PersonAi:update(dt)
    Entity.update(self, dt)
    self.currentThought:update(dt)
end

function PersonAi:render()
    Entity.render(self)
    self:renderThoughts()
end

--renders what the entity is thinking about
function PersonAi:renderThoughts()
	love.graphics.draw(gTextures[self.currentThought.texture], 
	gFrames[self.currentThought.texture][self.currentThought:getCurrentFrame()],
    math.floor(self.x+13), 
    math.floor(self.y-9) --10 px offset on the y cause the has some blank space of 10px
    )
end 

--changes the current thought of the entity
function PersonAi:changeThoughtAnimation(name)
    self.currentThought = self.thoughtAnimations[name]
end
