PlayState = Class {__includes = BaseState} -- inherit from base state

PIPE_SPEED = 50

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.ground = Ground()
    self.sky = Sky()
    self.bird = Bird()
    self.pipes = {}
    self.timer = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    self.score = 0
    self.paused = false
    self.genTime = 2
end

function PlayState:pauseGame()
    self.paused = not self.paused
end

function PlayState:update(dt)
    if love.keyboard.keysPressed['p'] then
        if self.paused then
            sounds['music']:play() --actually restarts the music, can't get :resume() to work for some reason
            sounds['pause']:play()
        else
            sounds['music']:pause()
            sounds['pause']:play()
        end
        self:pauseGame()
    end

    if not self.paused then

        self.timer = self.timer + dt

        -- add a new pipe every 2 seconds
        if self.timer > self.genTime then
            self.genTime = math.random(2,6)

            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10,
                    math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y

            table.insert(self.pipes, PipePair(y))
            self.timer = 0
        end

        -- for every pipe in the scene...
        for k, pair in pairs(self.pipes) do

            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then -- bird past the pipe's right side
                    self.score = self.score + 1
                    sounds['score']:play()
                    pair.scored = true
                end
            end
            pair:update(dt)
        end

        self.bird:update(dt)
        self.sky:update(dt)
        self.ground:update(dt)

        -- remove any flagged pipes
        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(self.pipes) do
            if pair.remove then
                table.remove(self.pipes, k)
            end
        end

        -- simple collision between bird and all pipes in pairs
        for k, pair in pairs(self.pipes) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()
                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        -- reset if we get to the top of the screen + buffer
        if self.bird.y < (BIRD_HEIGHT * -2) then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {
                score = self.score
            })
        end

        -- reset if we get to the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {
                score = self.score
            })
        end

    end
end

function PlayState:render()
    self.sky:render()

    for k,pipePair in pairs(self.pipes) do
        pipePair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
    self.ground:render()

    if self.paused then
        love.graphics.setFont(hugeFont)
        love.graphics.printf('||', 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')
    end

end
