push = require 'push'
Class = require 'class'

require 'paddle'
require 'ball'
require 'laser'
require 'helper'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 440
VIRTUAL_HEIGHT = 240

PADDLE_SPEED = 200

function love.load()
	love.window.setTitle('Battle Pong');
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true,
    canvas = false
  })

  math.randomseed(os.time())

  -- asset declarations
  textFont = love.graphics.newFont('assets/font.ttf', 8)
  scoreFont = love.graphics.newFont('assets/font.ttf', 32)

  sounds = {
    ['paddle_hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static'),
    ['laser_shoot'] = love.audio.newSource('assets/sounds/laser_shoot.wav', 'static'),
    ['hit'] = love.audio.newSource('assets/sounds/hit.wav', 'static')
  }

  gameState = 'start'

  winningPlayer = 0
  servingPlayer = math.random(2)

  player1Score = 0
  player2Score = 0

  player1 = Paddle(10, 10)
  player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 40)
  ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2);
end

function love.update(dt)
  if gameState == 'serve' then
    handleServeState()
  elseif gameState == 'play' then
    handlePlayState()
    player1:updateLasers(dt)
    player2:updateLasers(dt)
    ball:update(dt)
  elseif gameState == 'done' then
    handleDoneState()
  end
  handlePlayerInput();
  player1:update(dt)
  player2:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'lshift' then
    if gameState == 'play' then
      player1:shootLaser(1)
    end
  elseif key == 'rshift' then
    if gameState == 'play' then
      player2:shootLaser(-1)
    end
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'done' then
      restartGame()
    end
  end
end

function love.draw()
  push:apply('start')

  -- sets background color
  -- love.graphics.clear(2, 0.2, 0.2, 0.2)

  displayGameText()
  displayScores()
  displayHealths()
  displayReloading()

  player1:render()
  player2:render()
  ball:render()

  push:apply('end')
end
