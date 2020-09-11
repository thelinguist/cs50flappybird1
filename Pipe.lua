Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(topOrBottom, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
    self.orientation = topOrBottom
end

function Pipe:update(dt)
end

function Pipe:render()
    -- when you flip the graphic, the origin point is off, so account for that
    love.graphics.draw(
            PIPE_IMAGE,
            self.x,
            (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
            0, -- rotate
            1, -- x axis
            self.orientation == 'top' and -1 or 1) -- y axis (- is flip
end
