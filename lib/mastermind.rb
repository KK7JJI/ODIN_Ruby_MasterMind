# Entry point.  run.sh starts execution
# of the program here.
module Mastermind
  def self.run(args)
    puts "File: #{__FILE__.split('/')[-1]}, Running method: #{__method__}"
    app = Mastermind::App.new
    app.run(args)
  end
end

# Start the program if this file is executed directly
Mastermind.run(ARGV)
