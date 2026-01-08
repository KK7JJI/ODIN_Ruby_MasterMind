# frozen_string_literal: true

module Mastermind
  # represent individual game players. In Mastermind
  # we'll have a codemaker and a codebreaker.
  class Player
    include GameMsgs

    attr_accessor :player_role, :player_name, :player_score, :game

    def self.call(player_name:)
      new(player_name).call
    end

    def initialize(player_name)
      @player_name = player_name
      @player_score = 0
      @game = nil
    end

    def call
      self
    end

    def submit_until_valid(generator:, accepter:)
      value = ['z']
      until accepter.call(@game, value)
        print_code_help_msg(@game) unless computer_guess?
        value = generator.call(@game)
      end
      puts "Computer Guess: #{value}" if computer_guess?
    end

    def computer_guess?
      return true if instance_of?(Mastermind::ComputerPlayerMinMax)

      false
    end

    def submit_codebreaker_guess
      submit_until_valid(
        generator: method(:generate_codebreaker_guess),
        accepter: ->(mm, value) { mm.accept_codebreaker_guess(value) }
      )
      @game.codebreaker_guess_count += 1
      @game.calculate_codebreaker_guess_feedback
    end

    def submit_solution
      submit_until_valid(
        generator: method(:generate_solution),
        accepter: ->(mm, value) { mm.accept_codemaker_solution(value) }
      )
    end
  end

  # minmax players will make guesses using
  # minmax algorithm.  Codes are set at random
  class ComputerPlayerMinMax < Player
    def generate_solution(mastermind)
      Array.new(mastermind.sol_pos_count) { mastermind.valid_tokens.sample }
    end

    def generate_codebreaker_guess(mastermind)
      mastermind.sample_solution_space
    end
  end

  # human player selects a code via
  # commmand line prompt
  class HumanPlayer < Player
    def generate_solution(_mastermind)
      print '  Set Code:'
      $stdin.getpass.chomp.upcase.chars
    end

    def generate_codebreaker_guess(_mastermind)
      print 'Your guess: '
      $stdin.gets.chomp.upcase.chars
    end
  end

  # computer player selects a code at
  # random.
  class ComputerPlayerRandom < Player
    def generate_solution(mastermind)
      Array.new(mastermind.sol_pos_count) { mastermind.valid_tokens.sample }
    end

    def generate_codebreaker_guess(mastermind)
      Array.new(mastermind.sol_pos_count) { mastermind.valid_tokens.sample }
    end
  end
end
