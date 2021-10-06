Laser = Class{}

LASER_WIDTH = 10
LASER_HEIGHT = 2
LASER_SPEED = 300

function Laser:init(x, y, direction)
  self.x = x
  self.y = y
  self.width = LASER_WIDTH
  self.height = LASER_HEIGHT
  self.speed = LASER_SPEED * direction
  self.isActive = true
end

function Laser:update(dt)
  self.x = self.x + self.speed * dt
end

function Laser:render()
  if self.isActive then
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  end
end

function Laser:collided()

end