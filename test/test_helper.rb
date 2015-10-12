# require 'coveralls'
# Coveralls.wear!
require 'simplecov'
SimpleCov.start
require 'fakefs/safe'
require 'minitest/autorun'
require 'minitest/reporters'
require "simplecov-shield"

require "mastermind/oscar/game_manager"
require "mastermind/oscar/record_manager"
require "mastermind/oscar/codemaker"
require "mastermind/oscar/time_manager"
require "mastermind/oscar/printer"
require "stringio"

SimpleCov.formatter = SimpleCov::Formatter::ShieldFormatter
