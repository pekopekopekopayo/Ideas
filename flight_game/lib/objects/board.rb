# frozen_string_literal: true

require_relative 'base'
require_relative '../functions/drawable'

# Board class manages the game area and its boundaries
class Board
  include Drawable

  WIDTH = 10
  HEIGHT = 10
  BORDER_OFFSET = 2

  def initialize
    @width = WIDTH
    @height = HEIGHT
  end

  def draw(window)
    draw_border(window)
  end

  def in_bounds?(x, y)
    x.between?(1, @width) && y.between?(1, @height)
  end

  def center_position
    [@width / 2, @height / 2]
  end

  private

  def draw_border(window)
    (0..@height + 1).each do |row|
      (0..@width + 1).each do |col|
        draw_at(window, row, col, '·') if border_position?(row, col)
      end
    end
  end

  def border_position?(row, col)
    row.zero? || row == @height + 1 || col.zero? || col == @width + 1
  end
end
