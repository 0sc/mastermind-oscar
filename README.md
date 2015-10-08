# Mastermind::Oscar
[![coverage-badge](https://cdn.rawgit.com/andela-ooranagwa/mastermind-oscar/master/coverage/coverage.svg)](http://andela-ooranagwa.github.io/mastermind-oscar/coverage/#_AllFiles)

Mastermind_Oscar is a Ruby implementation of the classic board game of same name. The game is a code breaking game between two players; in this implementation, it is between a player and the computer.

The computer selects a random sequence of color characters whose length depends on the game level (beginner, intermediate and expert). The player tries to guess the sequence generated by the computer using the feedback from the computer at every attempt as a guide.
The game is over either when the player correctly guess the sequence or the player runs out of guesses; player has 12 guesses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mastermind-oscar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mastermind-oscar

## Usage

To play the game, open your terminal and run mastermind_oscar. You can also run the game with a desired level as an optional argument e.g mastermind_oscar intermediate

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/mastermind_oscar` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/andela-ooranagwa/mastermind-oscar/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
