# frozen_string_literal: true

require_relative '../functions/drawable'
require_relative '../functions/movable'
require_relative '../functions/collidable'

# base.rb
class Base
  include Drawable
  include Movable
  include Collidable

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.image
    raise NotImplementedError, "#{name}#image must be implemented"
  end

  def collision?(other)
    @x == other.x && @y == other.y
  end
end
