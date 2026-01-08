# frozen_string_literal: true

module Mastermind
  # store all possible game solutions for comparison
  # during gameplay.
  class Minmax
    attr_accessor :solutions, :feedback_set

    def self.call(game:)
      new(game).call(game)
    end

    def initialize(game)
      @solutions = generate_solution_set(game)
      @feedback_set = []
    end

    def call(game)
      self
    end

    def reset_game(game:)
      @solutions = generate_solution_set(game)
      @feedback_set = []
    end

    def generate_solution_set(game)
      permutations(game.valid_tokens, game.sol_pos_count)
    end

    def generate_solution_set2(game)
      # optionally you can use the built in permutations method.
      game.valid_tokens.repeated_permutation(game.sol_pos_count).to_a
    end

    def generate_feedback_set(guess:)
      @feedback_set = solutions.map do |solution|
        feedback(solution: solution, guess: guess)
      end
    end

    def update_solution_set(feedback:)
      indicies = (@feedback_set.map.with_index do |fb, idx|
        idx if fb == feedback
      end).compact

      @solutions = indicies.map { |i| solutions[i] }
      @feedback_set = []
    end

    def permutations(valid_tokens, pos_count)
      # ruby has a built in that does this.  I wrote one myself for the
      # sake of learning how to do it.
      return valid_tokens.map { |token| Array.new(1) { token } } if pos_count == 1

      perms = permutations(valid_tokens, pos_count - 1)
      tokens = valid_tokens.map { |token| Array.new(1) { token } }
      result = []
      tokens.each do |t|
        perms.each do |perm|
          result << (t + perm)
        end
      end
      result
    end

    def feedback(solution:, guess:)
      black_tokens = 0
      white_tokens = 0
      sol_unmatched = []
      guess_unmatched = []

      solution.zip(guess) do |sol, guess|
        if sol == guess
          black_tokens += 1
        else
          sol_unmatched << sol
          guess_unmatched << guess
        end
      end

      guess_unmatched.each do |guess|
        if (idx = sol_unmatched.index(guess))
          white_tokens += 1
          sol_unmatched.delete_at(idx)
        end
      end

      (['B'] * black_tokens) + (['W'] * white_tokens)
    end
  end
end
