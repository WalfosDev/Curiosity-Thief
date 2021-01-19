--[[
    Writes diologue incrementally. Word by word while playing a sound which is specified.
    Can press enter to skip to the full text. 

    Also when in the houseState the state will need to be offseted to where the player is, if so set the offsetCam argument to true.
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(player, offsetCam, sound, text, callback)
    self.player = player
    self.textbox = Textbox(0, 80, VIRTUAL_WIDTH, 48, "", gFonts['extra-small'])
    self.callback = callback or function() end

    self.offsetCamera = offsetCam

    self.textIsLoading = true

    self.fullText = text
    self.currentText = self.fullText:sub(1,1)
    self.lengthOfCurrentText = 1

    self.sound = sound

    gSounds[self.sound]:play()
    --imcriments diologue and makes it bigger
    self.timerThatLoadsText = Timer.every(0.05, function()
        --increases the length of the text, by cutting out a segment from the full text
        self.lengthOfCurrentText = self.lengthOfCurrentText + 1
        self.currentText = self.fullText:sub(1, self.lengthOfCurrentText) --snips the string to the current text length

        --if the current text is equal to the fullTextsLength or the text loading was skipped then load the fullText
        --and allows the player to leave this state
        if self.lengthOfCurrentText == self.fullText:len() or not self.textIsLoading then
            self.currentText = self.fullText
            self.textIsLoading = false
            self.timerThatLoadsText:remove()
        end
        --loads the actuall text
        self.textbox = Textbox(0, 80, VIRTUAL_WIDTH, 48, self.currentText, true, gFonts['extra-small'])
    end) --end of timer

end

function DialogueState:update(dt)
    self.textbox:update(dt)

    --skips the loading of text and makes the full text load
    if (love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) and self.textIsLoading then
        self.textIsLoading = false
        self.textbox = Textbox(0, 80, VIRTUAL_WIDTH, 48, self.fullText, false, gFonts['extra-small'])
    end

    --if the text is not loading and there is no more text left in the text box then pop this state
    if not self.textIsLoading then
        gSounds[self.sound]:stop()
        if self.textbox:isClosed() then
            gSounds['select1']:play()
            self.callback()
            gStateStack:pop()
        end
    end
end

function DialogueState:render()
    --sometimes the diologue may be needed to offset if in the house state.
    if self.offsetCamera then
        love.graphics.translate(math.floor(self.player.cameraScrollx), math.floor(self.player.cameraScrolly))
    end
    self.textbox:render()
end