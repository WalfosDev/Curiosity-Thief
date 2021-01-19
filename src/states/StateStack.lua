--[[
    Taken from GD50 ,Pokemon.
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to manage states in a stateStack.
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params, dt)
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state)
    table.insert(self.states, state)
    --state:enter()
end

function StateStack:pop()
    local lastStateWasFadeState

    --makes sure there is something in the stack
    if self.states[#self.states] then
        --helps fix bug where the fade state causes the enter to be opened twice
        lastStateWasFadeState = self.states[#self.states].isFadeState

        if type(self.states[#self.states].exit) == 'function' then
            self.states[#self.states]:exit()
        end
    end

    table.remove(self.states)

    if self.states[#self.states] then
        if type(self.states[#self.states].enter) == 'function' then
            self.states[#self.states]:enter(lastStateWasFadeState)
        end
    end

end