TitleScreenState = Class {__includes = BaseState} -- inherit from base state


function TitleScreenState:init()
    self.ground = Ground()
    self.sky = Sky()
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('touch') then
        gStateMachine:change('countdown')
    end

    self.sky:update(dt)
    self.ground:update(dt)
end

function TitleScreenState:render()
    self.sky:render()
    self.ground:render()

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Filthy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    --love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Tap to start', 0, 100, VIRTUAL_WIDTH, 'center')
end
