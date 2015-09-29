#require_relative "oscar/version"
require_relative "oscar/game_manager"

module Mastermind
  module Oscar
    extend self
    def mastermind
      GameManager.new.start_game
    end
  end
end

Mastermind::Oscar.mastermind