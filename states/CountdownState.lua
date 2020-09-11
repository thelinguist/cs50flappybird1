CountdownState = Class {__includes = BaseState}

COUNTDOWN_TIME = 0.75 -- let this much time elapse before starting timer...

function CountdownState:init()
    self.ground = Ground()
    self.sky = Sky()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if(self.count == 0) then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    self.sky.render()
    self.ground.render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end

