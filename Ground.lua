Ground = Class {}

-- images we load into memory from files to later draw onto the screen
local ground = love.graphics.newImage('ground.png')

local groundScroll = 0

local GROUND_SPEED = 50

local GROUND_LOOPING_POINT = 514

local scrolling = true

function Ground:update(dt)
    groundScroll = (groundScroll + GROUND_SPEED * dt) % GROUND_LOOPING_POINT
end

function Ground:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
end
