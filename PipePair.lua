PipePair = Class {}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['top'] = Pipe('top', self.y),
        ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + (GAP_HEIGHT * (math.random(80,150)/100)))
    }

    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false

    -- whether this pipe pair has been counted or not in the scoring
    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes.top.x = self.x
        self.pipes.bottom.x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k,pipe in pairs(self.pipes) do
        pipe:render()
    end
end
