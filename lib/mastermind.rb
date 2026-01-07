# Entry point.  run.sh starts execution
# of the program here.

require 'pry-byebug'
require_relative 'mastermind/app'
require_relative 'mastermind/solution_space'
require_relative 'mastermind/player'
require_relative 'mastermind/game'

module Mastermind
  def self.run(args)
    puts "File: #{__FILE__.split('/')[-1]}, Running method: #{__method__}"
    app = Mastermind::App.new
    app.run(args)
  end
end

# Start the program if this file is executed directly
Mastermind.run(ARGV)
