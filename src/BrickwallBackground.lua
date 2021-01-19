--[[
This class holds the information for the brick wall background scene in the game.

The brick wall background appears as a big brickwall which has spotlights moving around.
Along with this if the sound argument is set to true siren and helicopter noises play.

How the spotlights work is that there is a big black screen that is not entirely opaque on top the background,
which gives a shadow effect, then circles circles stencil this blackscreen making the effect of sudden brightness,
like a spotlight.
]]

BrickwallBackground = Class{__includes = BaseState}

function BrickwallBackground:init(sound)
	--instantiates the spotlights
	self.circle1 = {x =1, y =1, width = 16}
	self.circle2 = {x=math.random(1,190), y=math.random(1,110), width = 16}
	--tweens the spotlights to make them move around
	self:tweenSpotlights(self.circle1)
	self:tweenSpotlights(self.circle2)

	if sound then
		--plays the siren and helicopter sounds
		gSounds['distant_sirens']:play()
		gSounds['distant_sirens']:setVolume(0.2)
		gSounds['helicopter']:play()
		--there is a timer so that sound may activate randomly
		self.noiseTimers = Timer.every(3, function()
			local randomNoise = math.random(1,3)
			if randomNoise == 1 then
				gSounds['helicopter']:play()
			elseif randomNoise == 2 then
				gSounds['distant_sirens']:play()
			end
		end)
	end

end

--Tweens the spotlights to a new location
function BrickwallBackground:tweenSpotlights(spotlight)
	Timer.tween(math.random(8,12), {
        [spotlight] = {x = math.random(1,190), y = math.random(1,110), width = math.random(16,34)}
    }):finish(function()
    	self:tweenSpotlights(spotlight)
    end)

end

--should be called when exiting this state to stop music ect...
function BrickwallBackground:exit()
	if self.noiseTimers then
		gSounds['helicopter']:stop()
		gSounds['distant_sirens']:stop()
		self.noiseTimers:remove()
	end

end

function BrickwallBackground:render()
	--renders the brick wall
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(gTextures['brick_wall'], 0, 0)

	--stencills out the circles from the black shroud to make them look like spotlights.
    love.graphics.stencil(function()
        love.graphics.circle('fill', self.circle1.x,self.circle1.y, self.circle1.width,100)
        love.graphics.circle('fill', self.circle2.x,self.circle2.y, self.circle2.width,100)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)--starts stecilling
    --blackshroud gives the illusion of a shadow
	love.graphics.setColor(0,0,0,140)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	love.graphics.setStencilTest()--ends stencilling
end

