Class = require 'class'
push = require 'push'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/ContDownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local grounddScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- local bird = Bird()
-- local pipePairs = {}
-- local spawnTimer = 0

-- local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    gGameStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return ContDownState() end,
    }
    gGameStateMachine:change('title')

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keyspressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keyspressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keyspressed[key] then
        return true
    else     
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    grounddScroll = (grounddScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    gGameStateMachine:update(dt)

    love.keyboard.keyspressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    -- for k, pair in pairs(pipePairs) do
    --     pair:render()
    -- end
    gGameStateMachine:render()

    love.graphics.draw(ground, -grounddScroll, VIRTUAL_HEIGHT - 16)

    -- bird:render()

    push:finish()
end
