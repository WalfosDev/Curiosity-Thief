--[[
The tutorial is activated when the player chooses it in the opening dialogue. 
This causes the playState to initialize the player with the tutorial argument being set to true. 
Then the player initializes the TutorialManager class.  

The trutorial is structured such that as the player p[lays the actuall game it tells them whqat to do.

The TutorialManager manages all the dialogue and controls for the tutorial to work. 
The player must simply call the updateTutorial(action,stateInfo) function in houseState enter (), houseState init(), 
cashInMoneyState enter (), and cashInMoneyState init(). This function found in the player class then calls the tutorial 
manager to update itself. 

The tutorial dialogues work much in the same way as other dialogues in that every time the state 
is entered a value increases and for each specific value there is a dialogue.

The tutorial explains the following; movement, stealing, breaking objects, crime coeeficient, the gui panel and selling objects.

There is also a quick version of the tutorial.
]]
TutorialManager = Class{}

function TutorialManager:init(player, typeOfTutorial)
    self.player = player

    if typeOfTutorial == "quickTutorial" then
        self.timesEnteredHouseState = 2
        self.recap = 0
    else
        --all the tutorial values
        self.movement = 0
        self.stealing = 0
        self.recap = 0
        self.sellingItems = 0
        self.timesEnteredHouseState = 0
    end
end

--[[
This is the brain of the tutorial. According to what is left to be done in the tutorial it calls speciic functions to update that part of the tutorial.

To make sure this system works properly wheneverthe tutorial is called usually it sends feedback on what action called the tutorial. \
This is what the action argument does.
]]
function TutorialManager:updateTutorial(action,stateInfo)
    --The player can not pause during the tutorial because it will send a signal to the tutorialManger that the houseState was entered
    --which will trigger a false start on the tutorial and skip a diologue.
    self.player.canPause = false

    --if the tutorial update was called when the houseState was initialised.
    if action == 'houseState initialised' then
        self.timesEnteredHouseState = self.timesEnteredHouseState + 1
        --The first time you go in a new house the movement tutorial will be activated.
        if self.timesEnteredHouseState == 1 then
            self.player.canLeaveHouse = false
            self:movementTutorialUpdate(stateInfo)

        --The second time you go in a new house the stealing tutorial will be activated
        elseif self.timesEnteredHouseState == 2 then
            self.movement = false --removes the last tutorial type so the stealing tutorial can activate
            self.player.canLeaveHouse = false
            self:stealingTutorialUpdate(stateInfo)  

        --The third time you go in a new house the recap tutorial will be activated
        elseif self.timesEnteredHouseState == 3 then
            self.stealing = false --removes the last tutorial type so the recap tutorial can activate
            self.player.canLeaveHouse = false
            self:recapUpdate(stateInfo)
        end

    --if the tutorial update was called when the houseState was entered
    elseif action == 'houseState entered' then
        if self.movement and self.timesEnteredHouseState == 1 then
            self:movementTutorialUpdate(stateInfo)
        elseif self.stealing and self.timesEnteredHouseState == 2 then
            self:stealingTutorialUpdate(stateInfo)
        elseif self.recap and self.timesEnteredHouseState == 3 then
            self:recapUpdate(stateInfo)
        end

    --if the tutorial updated in the cashInMoneyState
    elseif action == 'cashInMoneyState' then
        self:sellingItemsUpdate(stateInfo)
    
    --if the tutorial was updated when the police spawnede
    elseif action == 'block police from spawning' then
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "I said leave, and hurry! I am holding off the cops for you."
        ))
    end

end

--This updtaes the tutorial for the movement section
function TutorialManager:movementTutorialUpdate(stateInfo)
    self.movement = self.movement + 1

    if self.movement == 1 then
        Timer.after(3, function()
            stateInfo.pauseTimer = true
            gSounds['radio']:play()
            gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Testing testing phew it works. To move up use:'"..moveUp.."'. To move down:'".. moveDown.."'. To move right:'".. moveRight .."'. To move left: '"..  moveLeft.."'",
            function()
                gSounds['radio']:play()
            end))
        end)

    elseif self.movement == 2 then
        Timer.after(5, function()
            stateInfo.pauseTimer = true
            gSounds['radio']:play()
            gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Now here comes the tricky part, leaving the house. First rule you can not come through the same door you entered from."
            ))
        end)

    elseif self.movement == 3 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Sometimes the door will be the same, sometimes they will be farr apart. Now walk to the door and press e to leave."
        ))

    elseif self.movement == 4 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "If anything is blocking your path press 'R' to break it."
        ))

    elseif self.movement == 5 then  
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "HURRY! The police will be here in "..tostring(stateInfo.timeTillPoliceSpawns).." seconds! If they come in a 1 tile radius of you, you lose."
        ))

    else
        self.player.canLeaveHouse = true
    end

end



--updates the stealing section of the tutorial
function TutorialManager:stealingTutorialUpdate(stateInfo)
    self.stealing = self.stealing + 1

    if self.stealing == 1 then
        Timer.after(5, function()
            stateInfo.pauseTimer = true
            gSounds['radio']:play()
            gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Now at the top of your screen you will see the ui panel. This tells you the main things you need to know.",
            function()
                gSounds['radio']:play()
            end))
        end)

    elseif self.stealing == 2 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "The 'time left' bar tells you how many seconds you have till the police arrive. It changes colour the less time you have left.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 3 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "The 'crime rate' bar is how much the police are aware of you. The higher your crime rate the faster police come.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 4 then  
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "When it is white you are in the clear. When it is yellow it means police are actively searching for you.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 5 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "If it is red that means you are extremely suspicious and have exceed the max crime rate of '"..tostring(self.player.maxCrimeCoefficient).."'. You have the minimum time.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 6 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "Your crime rate increases every time someone see's you or when you break objects.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 7 then
        Timer.after(5, function()
            stateInfo.pauseTimer = true
            gSounds['radio']:play()
            gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Ohh yeah onto the stealing part. In the UI panel it will tell you if something is stealable, just approach the object to know."
            ))
        end)

    elseif self.stealing == 8 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "If it is stealable the middle icon will go green, then just press e to steal it.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 9 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "Also one last thing 'PRESS R' to break objects, because sometimes things will be in hard to reach places.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.stealing == 10 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
        "But when you break objects it increases your crime rate, it is 'destruction of private property' after all. Now quick grab something and dash!",
        function()
            gSounds['radio']:play()
        end))

    else
        self.player.canLeaveHouse = true
    end

end



--updates the sellling items section of the tutorial
function TutorialManager:sellingItemsUpdate(stateInfo)
    self.sellingItems = self.sellingItems + 1

    if self.sellingItems == 1 then
        gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
        "This is where you sell the goods to me. I have already written the order out on paper."))

    elseif self.sellingItems == 2 then
        gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
        "If you have a lot of items press '"..tostring(moveUp).."' and '"..tostring(moveDown).."' to scroll through them."))

    elseif self.sellingItems == 3 then
        gStateStack:push(DialogueState(self.player, false,  'anonymous_talking',
        "Press enter when you are done looking at the items. If you have a bonus that will be done when you press enter too."))

    else
        self.sellingItems = false
    end

end



--updates the racap section of the tutorial
function TutorialManager:recapUpdate(stateInfo)
    self.recap = self.recap + 1

    if self.recap == 1 then
        Timer.after(4, function()
            stateInfo.pauseTimer = true
            gSounds['radio']:play()
            gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Okay so thats all for your tutorial. Here is a quick overview.",
            function()
                gSounds['radio']:play()
            end))
        end)

    elseif self.recap == 2 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Press e to steal, press R to break items, press e by the door to leave.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.recap == 3 then
        stateInfo.pauseTimer = true
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "The ui will tell you if you can steal an item.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.recap == 4 then  
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "The 'time left' is how much time you have left till police come and is affected by your crime rate.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.recap == 5 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "If a police comes in a 1 block radius of you, you lose. Finnaly press 'p' to pause the game, from there you can check your stats and quit.",
        function()
            gSounds['radio']:play()
        end))

    elseif self.recap == 6 then
        stateInfo.pauseTimer = true  
        gSounds['radio']:play()
        gStateStack:push(DialogueState(self.player, true,  'anonymous_talking',
            "Happy stealing. Remember to get me something good! I'll pick you up soon.",
        function()
            gSounds['radio']:play()
        end))

    else
        self.player.canPause = true
        self.player.canLeaveHouse = true
        self.recap = false
        self.player.tutorial = nil
    end

end