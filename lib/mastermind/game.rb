# frozen_string_literal: true

module Mastermind
  # Represents a single game of mastermind.
  class Game
    attr_accessor :solution, :sol_pos_count, :token_choice_count,
                  :valid_tokens, :codebreaker_guess, :codebreaker_guess_count,
                  :players, :sol_guess_count, :codebreaker_guess_feedback

    def self.call(
      sol_pos_count: 4,
      sol_guess_count: 12,
      token_choice_count: 6
    )
      new(
        sol_pos_count,
        sol_guess_count,
        token_choice_count
      ).call
    end

    def initialize(
      sol_pos_count,
      sol_guess_count,
      token_choice_count
    )
      @players = {}

      @codebreaker_guess = []
      @codebreaker_guess_feedback = ['A']
      @codebreaker_guess_count = 0

      @token_choice_count = token_choice_count
      @valid_tokens = ('A'...('A'.ord + @token_choice_count).chr).to_a

      @solution = []
      @sol_pos_count = sol_pos_count
      @sol_guess_count = sol_guess_count

      @solution_space = nil
    end

    def call
      @solution_space = SolutionSpace.call(game: self)
      self
    end

    def reset_game
      @solution = []
      @codebreaker_guess = []
      @codebreaker_guess_count = 0
      @codebreaker_guess_feedback = ['A']
      @solution_space.reset_game(game: self)
    end

    def save_player_info(player)
      if players[:codemaker].nil?
        save_player(player_obj: player, player_role: :codemaker)
      elsif players[:codebreaker].nil?
        save_player(player_obj: player, player_role: :codebreaker)
      else
        'Invalid: this is a two player game.'
      end
    end

    def save_player(player_obj:, player_role:)
      player_obj.game = self
      players[player_role.to_sym] = player_obj
      "#{player_obj.player_name} is the #{player_role}"
    end

    def reverse_player_roles
      temp = players[:codemaker]
      players[:codemaker] = players[:codebreaker]
      players[:codebreaker] = temp
    end

    def print_player_roles
      puts ''
      puts 'Player roles are assigned as follows:'
      puts '-------------------------------------'

      players.keys.sort.each do |key|
        puts "#{key} is #{players[key].player_name}"
      end
      puts ''
    end

    def print_player_scores
      player_score_msgs = []
      players.values.map do |player|
        player_score_msgs << "#{player.player_name} score: #{player.player_score}"
      end
      puts player_score_msgs.sort
    end

    def accept_codemaker_solution(sol)
      accept_value(:solution=, sol)
    end

    def accept_codebreaker_guess(sol)
      accept_value(:codebreaker_guess=, sol)
    end

    def accept_value(setter, sol) # rubocop:disable Naming/PredicateMethod
      return false unless valid_code?(sol)

      send(setter, sol)
      true
    end

    def valid_code?(sol)
      return false unless sol.length == @sol_pos_count
      return false unless sol.all? { |chr| @valid_tokens.include?(chr) }

      true
    end

    def sample_solution_space
      @solution_space.solutions.sample
    end

    def calculate_codebreaker_guess_feedback
      @codebreaker_guess_feedback =
        @solution_space.feedback(solution: solution, guess: codebreaker_guess)
    end

    def update_sol_feedback_set
      @solution_space.generate_feedback_set(guess: @codebreaker_guess)
    end

    def update_solution_space
      @solution_space.update_solution_set(feedback: codebreaker_guess_feedback)
    end

    def display_setcode_heading
      puts ''
      puts '------------------------'
      puts 'Select a code'
      puts "#{players[:codemaker].player_name}:"
      puts '------------------------'
      puts ''
    end

    def display_guess_heading
      puts ''
      puts '------------------------'
      puts "Guess: #{codebreaker_guess_count} of #{sol_guess_count}"
      puts "#{players[:codebreaker].player_name}:"
      puts '------------------------'
      puts ''
    end

    def display_guess_feedback
      puts ''
      puts 'Feedback for your guess:'
      puts '------------------------'
      puts "Guess = #{@codebreaker_guess.join}"
      puts "#{@codebreaker_guess_feedback.count('B')} tokens correct and in correct position."
      puts "#{@codebreaker_guess_feedback.count('W')} correct tokens but in wrong position."
      puts ''

      if @codebreaker_guess_feedback.all?('B') &&
         (@codebreaker_guess_feedback.length == @sol_pos_count)
        puts 'Congratulations! You have guessed the correct code!'
        puts "Code was: #{solution.join}"
        puts ''
      end
    end

    def game_over?
      return true if @codebreaker_guess_feedback.all?('B') &&
                     (@codebreaker_guess_feedback.length == @sol_pos_count)
      return true if @codebreaker_guess_count > @sol_guess_count

      false
    end
  end
end
