# frozen_string_literal: true

# Collidable module provides collision detection methods
module Collidable
  def collision?(other)
    @x == other.x && @y == other.y
  end
end
