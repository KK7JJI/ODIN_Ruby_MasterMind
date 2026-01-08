# frozen_string_literal: true

module Mastermind
  # Represents a single game of mastermind.
  class Game
    include Mastermind::GameMsgs
    include Mastermind::GameInput
    include Mastermind::GameSols
    include Mastermind::GamePlayers

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

    def initialize(sol_pos_count, sol_guess_count, token_choice_count)
      @players = {}

      @game_sets = 0
      @cur_set = 0

      @codebreaker_guess = []
      @codebreaker_guess_feedback = ['A']
      @codebreaker_guess_count = 1

      @token_choice_count = token_choice_count
      @valid_tokens = Array.new(token_choice_count) { |i| ('A'.ord + i).chr }

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

    def game_over?
      return true if codebreaker_wins?
      return true if codebreaker_loses?

      false
    end
  end
end
