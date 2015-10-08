require "mastermind/oscar/version"
require "mastermind/oscar/game_manager"

module Mastermind
  module Oscar
    extend self
    def mastermind
      $*.empty? ? arg = nil : arg = Mastermind::Oscar.game_level($*.first[0]) 
      game = Mastermind::Oscar::GameManager.new(arg)
      game.start_game
    end
  end
end
