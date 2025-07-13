# frozen_string_literal: true

require 'curses'
require 'io/console'
require_relative 'lib/objects/base'
require_relative 'lib/objects/player'
require_relative 'lib/objects/bullet'
require_relative 'lib/objects/enemy'
require_relative 'lib/objects/board'

class Game
  ENEMY_SPAWN_INTERVAL = 1.0
  FRAME_DELAY = 0.05

  # Board에서 호출할 수 있도록 public으로 선언
  def draw_at(y, x, char)
    Curses.setpos(y + Board::BORDER_OFFSET, x)
    Curses.addstr(char)
  end

  def initialize
    init_curses
    init_game_state
  end

  def run
    game_loop
  end

  private

  def init_curses
    Curses.init_screen
    Curses.curs_set(0)
    Curses.noecho
    Curses.stdscr.keypad(true)
    Curses.timeout = 0
  end

  def init_game_state
    @board = Board.new
    @player = Player.new(Board::WIDTH / 2, Board::HEIGHT - 2)
    @bullets = []
    @enemies = []
    @last_enemy_move_time = Time.now
    @running = true
  end

  def game_loop
    while @running
      update
      render
      handle_input
      sleep FRAME_DELAY
    end
  end

  def update
    move_enemies
    update_bullets
    spawn_enemy
  end

  def render
    Curses.clear
    @board.draw(self)
    draw_game_objects
    draw_ui
    Curses.refresh
  end

  def should_move_enemies?
    Time.now - @last_enemy_move_time >= ENEMY_SPAWN_INTERVAL
  end

  def spawn_enemy
    return unless @enemies.empty?

    @enemies << Enemy.new(rand(1..Board::WIDTH), 1)
  end

  def update_bullets
    @bullets.each do |bullet|
      bullet.move_up
      remove_collided_enemies(bullet)
    end
    remove_out_of_bounds_bullets
  end

  def remove_collided_enemies(bullet)
    @enemies.reject! do |enemy|
      if bullet.collision?(enemy)
        show_explosion(enemy)
        true
      end
    end
  end

  def show_explosion(enemy)
    draw_at(enemy.y, enemy.x, enemy.explode)
  end

  def remove_out_of_bounds_bullets
    @bullets.reject! { |bullet| bullet.y < 1 }
  end

  def draw_game_objects
    draw_enemies
    draw_player
    draw_bullets
  end

  def draw_enemies
    @enemies.each do |enemy|
      handle_game_over(enemy) if enemy.game_over?(Board::HEIGHT, @player)
      draw_at(enemy.y, enemy.x, Enemy.image)
    end
  end

  def draw_player
    draw_at(@player.y, @player.x, Player.image)
  end

  def draw_bullets
    @bullets.each { |bullet| draw_at(bullet.y, bullet.x, Bullet.image) }
  end

  def draw_ui
    Curses.setpos(0, 0)
    Curses.addstr('방향키로 이동, 스페이스로 발사, q로 종료')
  end

  def move_enemies
    return unless should_move_enemies?

    @enemies.each do |enemy|
      enemy.move_down
      handle_game_over(enemy) if enemy.game_over?(Board::HEIGHT, @player)
    end
    @last_enemy_move_time = Time.now
  end

  def handle_game_over(_enemy)
    @running = false
    show_game_over
  end

  def show_game_over
    center_x, center_y = @board.center_position

    Curses.clear
    draw_at(center_y, center_x - 5, 'Game Over!')
    draw_at(center_y + 1, center_x - 10, '아무 키나 누르면 종료됩니다')
    Curses.refresh
    wait_for_key
  end

  def wait_for_key
    $stdin.getch
    cleanup
  end

  def cleanup
    Curses.close_screen
    exit
  end

  def handle_input
    case Curses.getch
    when Curses::KEY_UP, 'w'    then move_player(:up)
    when Curses::KEY_DOWN, 's'  then move_player(:down)
    when Curses::KEY_LEFT, 'a'  then move_player(:left)
    when Curses::KEY_RIGHT, 'd' then move_player(:right)
    when ' ', 32                then fire_bullet
    when 'q', 'Q' then cleanup
    end
  end

  def move_player(direction)
    case direction
    when :up    then @player.move_up if @player.y > 1
    when :down  then @player.move_down if @player.y < Board::HEIGHT
    when :left  then @player.move_left if @player.x > 1
    when :right then @player.move_right if @player.x < Board::WIDTH
    end
  end

  def fire_bullet
    @bullets << Bullet.new(@player.x, @player.y - 1) if can_fire?
  end

  def can_fire?
    @bullets.size < Bullet::MAX_COUNT
  end
end

# 게임 시작
Game.new.run
