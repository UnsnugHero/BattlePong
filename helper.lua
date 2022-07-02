function handlePlayerInput(gameState)
  if gameState ~= 'paused' then
    if love.keyboard.isDown('up') then
      player2.speed = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
      player2.speed = PADDLE_SPEED
    else
      player2.speed = 0
    end

    if love.keyboard.isDown('w') then
      player1.speed = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
      player1.speed = PADDLE_SPEED
    else
      player1.speed = 0
    end
  end
end

function restartGame()
  if winningPlayer == 1 then
    servingPlayer = 2
  else
    servingPlayer = 1
  end
  player1.score = 0
  player2.score = 0
  gameState = 'serve'
end

function playerScores(player, opponent, server)
  player.score = player.score + 1
  gameState = 'serve'
  servingPlayer = server
  ball:reset()
  sounds['score']:play()
  player1.health = 3
  player2.health = 3
  player1.activeLasers = {}
  player2.activeLasers = {}
end

--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
  Display Functions
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]

function displayGameText()
  love.graphics.setFont(textFont)
  if gameState == 'start' then
    love.graphics.printf('Welcome to pong! Press enter to start and to serve', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState =='serve' then
    love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' serves!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'done' then
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins! Press enter to restart', 0, 20, VIRTUAL_WIDTH, 'center')
  end
end

function displayScores()
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayHealths()
  love.graphics.setFont(textFont)
  love.graphics.printf('HEALTH: ' .. tostring(player1.health), 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH / 2, 'center')
  love.graphics.printf('HEALTH: ' .. tostring(player2.health), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH / 2, 'center')
end

function displayReloading()
  love.graphics.setFont(textFont)
  if player1.timeUntilReloaded > 0 then
    love.graphics.printf('RELOADING...', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH / 2, 'center')
  end
  if player2.timeUntilReloaded > 0 then
    love.graphics.printf('RELOADING...', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH / 2, 'center')
  end
end

--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
  State Handlers
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]

function handleServeState()
  if player1.score == 10 or player2.score == 10 then
    gameState = 'done'
  end
  ball.verticalSpeed = math.random(-50, 50)
  if servingPlayer == 1 then
    ball.horizontalSpeed = math.random(100, 140)
  else
    ball.horizontalSpeed = math.random(-100, -140)
  end
end

function handlePlayState()
  handlePaddleCollisions()
  handleWallCollisions()
  handleIfHealthZeroOrScore()
  handleLaserCollisions(player1, player2)
  handleLaserCollisions(player2, player1)
  handleLasersOutOfBounds(player1)
  handleLasersOutOfBounds(player2)
end

function handleDoneState()
  if player1.score == 3 then
    winningPlayer = 1
  else
    winningPlayer = 2
  end
end

--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
  Handlers/Checks
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]

function collided(object1, object2)
  if object1.x > object2.x + object2.width or object2.x > object1.x + object1.width then
    return false
  end
  if object1.y > object2.y + object2.height or object2.y > object1.y + object1.height then
      return false
  end 
  return true
end

function handleLaserCollisions(player, opponent)
  if table.getn(opponent.activeLasers) ~= 0 then
    for index, laser in pairs(opponent.activeLasers) do
      if collided(laser, player) then
        player:handleLaserCollision()
        table.remove(opponent.activeLasers, index)
      end
    end
  end
end

function isLaserOutOfBounds(laser)
  return laser.x + laser.width < 0 or laser.x > VIRTUAL_WIDTH
end

function handleLasersOutOfBounds(player)
  if table.getn(player.activeLasers) ~= 0 then
    for index, laser in pairs(player.activeLasers) do
      if isLaserOutOfBounds(laser) then
        table.remove(player.activeLasers, index)
      end
    end
  end
end

function handleIfHealthZeroOrScore()
  if ball.x + ball.width < 0 or player1.health < 1 then
    playerScores(player2, player1, 1)
  elseif ball.x > VIRTUAL_WIDTH or player2.health < 1 then
    playerScores(player1, player2, 2)
  end
end

function handlePaddleCollisions()
  if collided(ball, player1) then
    ball:handleCollision(player1)
    ball.x = player1.x + player1.width
    sounds['paddle_hit']:play()
  end
  if collided(ball, player2) then
    ball:handleCollision(player2)
    ball.x = player2.x - ball.width
    sounds['paddle_hit']:play()
  end
end

function handleWallCollisions()
  if ball.y <= 0 then
    ball.y = 0
    ball.verticalSpeed = -ball.verticalSpeed
    sounds['wall_hit']:play()
  elseif ball.y >= VIRTUAL_HEIGHT - ball.height then
    ball.y = VIRTUAL_HEIGHT - ball.height
    ball.verticalSpeed = -ball.verticalSpeed
    sounds['wall_hit']:play()
  end
end