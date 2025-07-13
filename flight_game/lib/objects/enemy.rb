# frozen_string_literal: true

require_relative 'base'

# Enemy class represents the opponents that move down
class Enemy < Base
  def self.image
    'O'
  end

  def explode
    '☆'
  end

  def game_over?(height, player)
    @y >= height || collision?(player)
  end
end
