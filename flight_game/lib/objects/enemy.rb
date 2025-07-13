# frozen_string_literal: true

require_relative 'base'

class Enemy < Base
  SCORE_VALUE = 100

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
