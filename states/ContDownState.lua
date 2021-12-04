ContDownState = Class {__includes = BaseState}

COUNTDOWN_TIME = 0.75

function ContDownState:init()
    self.count = 3
    self.timer = 0
end

function ContDownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gGameStateMachine:change('play')
        end
    end
end

function ContDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end