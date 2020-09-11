--[[
    GD50
    Flappy Bird Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'Ground'
require 'Sky'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/ScoreState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

gOS = love.system.getOS()

function love.load()
    math.randomseed(os.time())

    handleMobileResize()

    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Filthy Bird')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf',14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf',56) -- countdown
    love.graphics.setFont(flappyFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- prefix global variable with g-
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

    gHiScore = 0

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['pause'] = love.audio.newSource('sounds/freezetime.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }
    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keysPressed = {}
    gTouch = {}

end

function love.displayrotated(index, rotation)
    handleMobileResize()
end

function love.focus( isFocused )
    --if not isFocused then
    --    love.audio.stop()
    --
    --else
    --    sounds['music']:play()
    --end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.audio.stop()

        if gStateMachine.isPlaying then
            PlayState:pauseGame()
        end
    end

end

function love.touchpressed( id, x, y, dx, dy, pressure )
    love.keyboard.keysPressed.touch = true
    gTouch = {
        x = x,
        y = y,
        id = id
    }
end


function love.mousepressed(x,y,button)
    love.keyboard.keysPressed['space'] = true
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    gTouch = {}
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function handleMobileResize()
    local screenWidth, screenHeight = love.window.getDesktopDimensions()

    if screenWidth < WINDOW_WIDTH then
        WINDOW_WIDTH = screenWidth
    end

    if screenHeight < WINDOW_HEIGHT then
        WINDOW_HEIGHT = screenHeight
    end
end
