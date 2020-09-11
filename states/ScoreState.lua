ScoreState = Class {__includes = BaseState} -- inherit from base state

function ScoreState:init()
    self.score = 0
    self.newRecord = false
    self.medal = love.graphics.newImage('1stplace.png')
    self.ten = love.graphics.newImage('10.png')
    self.fifteen = love.graphics.newImage('15.png')

end
function ScoreState:enter(changeParams)
    self.score = changeParams.score
end

function ScoreState:update(dt)
    if gHiScore < self.score and not self.newRecord then
        gHiScore = self.score
        self.newRecord = true
    end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('touch') then
            gStateMachine:change('countdown')
        end
    end

function ScoreState:render()
    love.graphics.setFont(flappyFont)

    if self.newRecord then
        love.graphics.printf('New Record', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(self.medal,VIRTUAL_WIDTH / 2, (VIRTUAL_HEIGHT / 2) + 80, 0, .1,.1, 334, 324)
    else
        love.graphics.printf('So close!', 0, 64, VIRTUAL_WIDTH, 'center')
    end

    if self.score > 5 then
        love.graphics.draw(self.ten,VIRTUAL_WIDTH / 3, (VIRTUAL_HEIGHT / 2) + 80, 0, .1,.1, 122, 321)
    end

    if self.score > 10 then
        love.graphics.draw(self.fifteen,VIRTUAL_WIDTH * 2/3, (VIRTUAL_HEIGHT / 2) + 80, 0, .1,.1, 122, 321)
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Tap to Play Again', 0, 160, VIRTUAL_WIDTH, 'center')
    --love.graphics.printf('Press Enter to Play Again', 0, 160, VIRTUAL_WIDTH, 'center')
end
