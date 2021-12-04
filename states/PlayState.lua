PlayState = Class {__includes = BaseState}

PIPE_SPEED = math.random(200, 300)
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.socre = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2 then
        local gap_height = math.random(90, 100)
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-25.5, 25.5), VIRTUAL_HEIGHT - gap_height - PIPE_HEIGHT)
        )
        self.lastY = y

        table.insert(self.pipePairs, PipePair(self.lastY, gap_height))
        self.spawnTimer = 0
    end


    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)

        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.socre = self.socre + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
    end

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gGameStateMachine:change('score', {
                    score = self.socre
                })
            end
        end
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gGameStateMachine:change('score', {
            score = self.socre
        })
    end
end

function PlayState:render() 
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.socre), 8, 8)

    self.bird:render()
end