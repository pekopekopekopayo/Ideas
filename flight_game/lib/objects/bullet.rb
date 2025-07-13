# frozen_string_literal: true

require_relative 'base'

# bullet.rb
class Bullet < Base
  MAX_COUNT = 5

  def self.image
    '|'
  end
end
