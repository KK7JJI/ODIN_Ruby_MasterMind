# frozen_string_literal: true

module Mastermind
  # Represents a single game of mastermind.
  class Game
    include Mastermind::GameMsgs

    attr_accessor :solution, :sol_pos_count, :token_choice_count,
                  :valid_tokens, :codebreaker_guess, :codebreaker_guess_count,
                  :players, :sol_guess_count, :codebreaker_guess_feedback,
                  :game_sets, :cur_set

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
      @game_sets = 0
      @cur_set = 0
      @codebreaker_guess = []
      @codebreaker_guess_feedback = ['A']
      @codebreaker_guess_count = 1

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
      @codebreaker_guess_count = 1
      @codebreaker_guess_feedback = ['A']
      @solution_space.reset_game(game: self)
    end

    def save_player_info(player)
      if players[:codebreaker].nil?
        save_player(player_obj: player, player_role: :codebreaker)
      elsif players[:codemaker].nil?
        save_player(player_obj: player, player_role: :codemaker)
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

    def codebreaker_wins?
      return true if @codebreaker_guess_feedback.all?('B') &&
                     (@codebreaker_guess_feedback.length == @sol_pos_count)

      false
    end

    def codebreaker_loses?
      return true if @codebreaker_guess_count > @sol_guess_count

      false
    end

    def game_over?
      return true if codebreaker_wins?
      return true if codebreaker_loses?

      false
    end

    def update_player_score
      players[:codebreaker].player_score += 1 unless codebreaker_loses?
    end
  end
end
