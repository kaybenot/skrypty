require 'ruby2d'

set title: "Mario"
set width: 800, height: 600

# Gracz
class Player
  attr_reader :sprite, :x, :y, :width, :height, :camera_x

  def initialize
    @sprite = Sprite.new(
      'images/mario.png',
      x: 100, y: 500,
      width: 52, height: 64,
      clip_width: 13, clip_height: 16,
    )
    @x = 100
    @y = 0
    @width = @sprite.width
    @height = @sprite.height
    @velocity_y = 0
    @velocity_x = 0
    @camera_x = 0
    @on_ground = false
  end

  def move_left
    @velocity_x = -5
  end

  def move_right
    @velocity_x = 5
  end

  def jump
    if @on_ground
      @velocity_y = -20
      @on_ground = false
    end
  end

  def update(platforms)
    @velocity_y += 1

    @x += @velocity_x
    @sprite.x = @x - @camera_x

    @camera_x = @x - 400 if @x > 400

    platforms.each do |platform|
      if intersects?(platform)
        if @velocity_x > 0
          @x = platform.x - @width
          @sprite.x = @x - @camera_x
        elsif @velocity_x < 0
          @x = platform.x + platform.width
          @sprite.x = @x - @camera_x
        end
        @velocity_x = 0
      end
    end

    @y += @velocity_y
    @sprite.y = @y

    platforms.each do |platform|
      if intersects?(platform)
        if @velocity_y > 0
          @y = platform.y - @height
          @sprite.y = @y
          @velocity_y = 0
          @on_ground = true
        elsif @velocity_y < 0
          @y = platform.y + platform.height
          @sprite.y = @y
          @velocity_y = 0
        end
      end
    end

    @velocity_x = 0

    if @y > Window.height
      reset_position
    end
  end

  def reset_position
    @x = 100
    @y = 0
    @sprite.x = @x
    @sprite.y = @y
    @velocity_y = 0
    @velocity_x = 0
    @camera_x = 0
    @on_ground = false
  end

  private

  def intersects?(platform)
    @x < platform.x + platform.width &&
    @x + @width > platform.x &&
    @y < platform.y + platform.height &&
    @y + @height > platform.y
  end
end

class Platform
  attr_reader :x, :y, :width, :height

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
    @rect = Rectangle.new(
      x: x, y: y,
      width: width, height: height,
      color: 'gray'
    )
  end

  def update(offset_x)
    @rect.x = @x - offset_x
  end
end

# Ustawienie mapy
platforms = [
  Platform.new(0, 550, 600, 50),
  Platform.new(900, 550, 300, 50),
  Platform.new(1300, 550, 500, 50),
  Platform.new(1900, 550, 300, 50),

  Platform.new(300, 400, 200, 50),
  Platform.new(700, 350, 200, 50),
  Platform.new(1100, 300, 200, 50),
  Platform.new(1500, 250, 200, 50),
  Platform.new(1800, 200, 200, 50),

  Platform.new(600, 550, 100, 50),
  Platform.new(1000, 500, 100, 50),
  Platform.new(1400, 450, 100, 50),
  Platform.new(1700, 400, 100, 50)
]

player = Player.new

on :key_held do |event|
  if event.key == 'a'
    player.move_left
  elsif event.key == 'd'
    player.move_right
  end
end

on :key_down do |event|
  if event.key == 'space'
    player.jump
  end
end

update do
  player.update(platforms)

  platforms.each do |platform|
    platform.update(player.camera_x)
  end
end

show
