Paddle = Class{}

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 26

function Paddle:init(x, y)
  self.x = x
  self.y = y
  self.width = PADDLE_WIDTH
  self.height = PADDLE_HEIGHT
  self.speed = 0

  self.score = 0
  self.health = 3
  self.timeUntilReloaded = 0
  

  self.activeLasers = {}
end

function Paddle:update(dt)
  if self.speed < 0 then
    self.y = math.max(0, self.y + self.speed * dt)
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.speed * dt)
  end
  self.timeUntilReloaded = math.max(0, self.timeUntilReloaded - dt)
end

function Paddle:handleLaserCollision()
  sounds['hit']:play()
  self.health = self.health - 1
end

function Paddle:shootLaser(direction)
  if self.timeUntilReloaded == 0 then
    self.timeUntilReloaded = 0.5

    xPos = self.x
    if direction == -1 then xPos = xPos - PADDLE_WIDTH end
    sounds['laser_shoot']:play()

    table.insert(self.activeLasers, Laser(xPos, self.y + self.height / 2, direction))
  end
end

function Paddle:updateLasers(dt)
  if table.getn(self.activeLasers) ~= 0 then
    for index, laser in pairs(self.activeLasers) do
      laser:update(dt)
    end
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

  -- render paddle's laser(s)
  if table.getn(self.activeLasers) ~= 0 then
    for index, laser in pairs(self.activeLasers) do
      laser:render()
    end
  end
end