# frozen_string_literal: true

module Mastermind
  # Represents a single game of mastermind.
  class Game
    include Mastermind::GameMsgs
    include Mastermind::GameInput
    include Mastermind::GamePlayers
    include Mastermind::GameSols

    attr_accessor :solution, :codebreaker_guess, :codebreaker_guess_count,
                  :players, :game_sets, :cur_set, :codebreaker_guess_feedback

    attr_reader :sol_guess_count, :valid_tokens, :token_choice_count,
                :sol_pos_count, :minmax_data

    def self.call(sol_pos_count:, sol_guess_count:, token_choice_count:)
      new(sol_pos_count, sol_guess_count, token_choice_count).call
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

      @minmax_data = Minmax.call(game: self)
    end

    def call
      self
    end

    def reset_game
      self.solution = []
      self.codebreaker_guess = []
      self.codebreaker_guess_count = 1
      self.codebreaker_guess_feedback = ['A']
      minmax_data.reset_game
    end

    def game_over?
      return true if codebreaker_wins?
      return true if codebreaker_loses?

      false
    end
  end
end
