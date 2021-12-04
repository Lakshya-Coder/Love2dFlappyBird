PipePair = Class {}

local GAP_HEIGHT = math.random(90, 100)

function PipePair:init(y, gap_height)
    GAP_HEIGHT = gap_height
    self.x = VIRTUAL_WIDTH + 100
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_HEIGHT then
        self.x = self.x - PIPE_SPEED * dt

        self.pipes['upper'].x = self.x + 10
        self.pipes['lower'].x = self.x + 10
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end