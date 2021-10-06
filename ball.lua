Ball = Class{}

BALL_DIMENSION = 3

function Ball:init(x, y)
  self.x = x - BALL_DIMENSION
  self.y = y - BALL_DIMENSION
  self.width = BALL_DIMENSION
  self.height = BALL_DIMENSION
  self.verticalSpeed = math.random(-50, 50)
  self.horizontalSpeed = math.random(140, 170)
end

function Ball:update(dt)
  self.y = self.y + self.verticalSpeed * dt
  self.x = self.x + self.horizontalSpeed * dt
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:handleCollision(player)
  self.horizontalSpeed = -self.horizontalSpeed * 1.1
  self.verticalSpeed = math.random(-200, 200)
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - BALL_DIMENSION
  self.y = VIRTUAL_HEIGHT / 2 - BALL_DIMENSION
  self.verticalSpeed = 0
  self.horizontalSpeed = 0
end
