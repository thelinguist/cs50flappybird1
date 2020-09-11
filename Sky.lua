Sky = Class {}

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')

local backgroundScroll = 0

local BACKGROUND_SPEED = 30

local BACKGROUND_LOOPING_POINT = 413 -- end of the image

function Sky:update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
end

function Sky:render()
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
end
