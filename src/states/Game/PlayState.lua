--[[
   The playState basically organizes the game and calls different states onto the stack at the appropriate times. 
   When the playSate is initialized it also initializes the player class, it is initialized here so that info on 
   how many houses the player has robbed etc... is only lost when the player exits the game or the playState is popped. 

    Firstly, the playstate will always push the houseState unless it pushes another state before. 
    When the player exits the houseState the game enters back into the playState which in turn pushes another houseState 
    and increases the amountOfHousesThePlayerRobbed variable. After a few houses have been robbed the player is offered 
    to go into the cashInMoneyState to sell items, or they can continue robbing to get a multiplier on the next time they 
    sell items. This is done using a menu GUI. After that the process is repeated so after another few houses the player 
    will be offered to sell their stuff. 

    Occasionally under certain conditions the playState may push an animation from the animationStates. 
]]


PlayState = Class{__includes = BaseState}

function PlayState:init(tutorialEnabled)
	--instantiates player
	self.player = Player(tutorialEnabled)
	self.menu = false

    self.highCrimeRateAnimationNotPlayed = true
    self.firstTimeSelling = true
    self.numberOfHousesTillCashInMoney = 2
end

function PlayState:enter(lastStateWasFadeState)
    --If the players crime rate is higher than the max the intense_music does not stop and the calm music won't play giving a sense of intensity
    if self.player.crimeCoefficient < self.player.maxCrimeCoefficient then
        gSounds['music_intense']:stop()
        gSounds['music_calm']:play()
        gSounds['music_calm']:setVolume(0.5)
        gSounds['music_calm']:setLooping(true)
    end

    --This state may be entered twice because of the fadeState and other state both popping so if the last state was the fadeSate then it will not register
    if not lastStateWasFadeState then
        --increases the number of houses robbed
        self.player.numberOfHousesRobbed = self.player.numberOfHousesRobbed + 1

        --if the players crimeRate is higher than the max then an animation is played once
        if (self.player.crimeCoefficient > self.player.maxCrimeCoefficient) and self.highCrimeRateAnimationNotPlayed then
            self.highCrimeRateAnimationNotPlayed = false
            self.player.numberOfHousesRobbed = self.player.numberOfHousesRobbed - 1
            gStateStack:push(HighCrimeRateDialogue(self.player))
        end

        --if the player reaches the number of required houses then they are offered the option to sell their stuff
        if (self.player.numberOfHousesRobbed == self.numberOfHousesTillCashInMoney) then
            --when we come back from this function it will interpret it as if we came back from the house state so we do not increase house robbed
            self.player.numberOfHousesRobbed = self.player.numberOfHousesRobbed - 1

            --if it's the players first time selling then a diologue plays
            if self.firstTimeSelling then
                self.firstTimeSelling = false
                gStateStack:push(DialogueState(self.player, false, 'anonymous_talking',
                "Phew you made it! You can sell now, or you can sell later to get a multiplier the next time you sell."))
            else
                --increases the amount of houses required to be robbed so the player can sell their stuff
                self.numberOfHousesTillCashInMoney = self.player.numberOfHousesRobbed + math.random(3,6)
            end

            --menu to select wheather you want to continue or sell items
        	self.menu = Menu {
        		player = self.player,
                x = 0,
                y = 80,
                width = VIRTUAL_WIDTH,
                height = 48,
                items = {
                    {
                        text = 'Sell Items',
                        onSelect = function()
                            self.menu = nil
                            gStateStack:push(CashInMoneyState(self.player))
                        end
                    },
                    {
                        text = 'Continue',
                        onSelect = function()
                            self.menu = nil
                            self.player.cashInMoneyMultiplier = self.player.cashInMoneyMultiplier + (math.random(10,70)/100)
                        	gStateStack:push(HouseState(self.player))
                        end
                    }
                }
            }
        else 
            self.menu = false
        end
    end--end of makes sure isn't fade state

end

function PlayState:update(dt)
	if self.menu then
    	self.menu:update(dt)
    else
        gStateStack:push(FadeState("black", 1, "in", function()
            gStateStack:push(HouseState(self.player))
            gStateStack:push(FadeState("black", 1, "out", function() end))
        end))--end of first fade state function
	end

end

function PlayState:render()
	if self.menu then
    	self.menu:render()
    end
end