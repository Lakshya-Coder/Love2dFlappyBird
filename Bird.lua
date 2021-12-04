Bird = Class {}

local GRAVITY = 5

local image1 = love.graphics.newImage('bird1.png')
local image2 = love.graphics.newImage('bird2.png')
local image3 = love.graphics.newImage('bird3.png')

function Bird:init()
    -- self.image1 = love.graphics.newImage('bird1.png')
    -- self.image2 = love.graphics.newImage('bird2.png')
    -- self.image3 = love.graphics.newImage('bird3.png')

    self.width = image1:getWidth()
    self.height = image2:getHeight()
    self.counter = 1

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -1.2
        sounds['jump']:play()
    end

    self.y = math.max(0, self.y + self.dy)
end

function Bird:getBirdImage()
    if self.counter == 1 then
        self.counter = self.counter + 1
        return image1
    elseif self.counter == 2 then
        self.counter = self.counter + 1
        return image2
    else
        self.counter = 1
        return image3
    end
end

function Bird:render()
    love.graphics.draw(self:getBirdImage(), self.x, self.y)
end

function Bird:collides(pipe)
    if ((self.x + 2) + (self.width - 4) >= pipe.x and (self.x + 2) <= pipe.x + PIPE_WIDTH) then
        if ((self.y + 2) + (self.height - 4) >= pipe.y and (self.y + 2) <= pipe.y + PIPE_HEIGHT) then
            return true
        end
    end

    return false
end
