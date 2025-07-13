# frozen_string_literal: true

# Movable module provides basic movement methods
module Movable
  def move_up
    @y -= 1
  end

  def move_down
    @y += 1
  end

  def move_left
    @x -= 1
  end

  def move_right
    @x += 1
  end
end
