# frozen_string_literal: true

# Drawable module provides methods for rendering objects on screen
module Drawable
  def draw_at(window, y, x, char)
    window.draw_at(y, x, char)
  end
end
