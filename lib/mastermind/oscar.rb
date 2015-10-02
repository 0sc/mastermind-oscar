require "mastermind/oscar/version"
require "mastermind/oscar/game_manager"

module Mastermind
  module Oscar
    extend self
    def mastermind
      Mastermind::Oscar::GameManager.new.start_game
    end
  end
end
puts "called with #{$*}"

Mastermind::Oscar.mastermind