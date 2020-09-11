Bird = Class{}

GRAVITY = 20


function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + (GRAVITY * dt)

    if love.keyboard.keysPressed['space'] or love.keyboard.keysPressed['touch'] then
        sounds['jump']:play()
        self.dy = - 5
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

-- AABB collision detection
--[[
    pipe needs an x and a y coordinate (right and bottom are given via global vars)
]]
function Bird:collides(pipe)
    local pipeRight = pipe.x + PIPE_WIDTH
    -- add some leeway for the players (2 pixels on all sides)
    local birdLeft = self.x + 2
    local birdRight = birdLeft + (self.width - 4)

    if birdRight >= pipe.x and
           birdLeft <= pipeRight then

        if (self.y + 2) + (self.height - 4) >= pipe.y
                and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end
