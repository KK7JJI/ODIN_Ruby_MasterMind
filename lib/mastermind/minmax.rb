# frozen_string_literal: true

module Mastermind
  # store all possible game solutions for comparison
  # during gameplay.
  class Minmax
    attr_accessor :solutions, :feedback_set

    def self.call(game:)
      new(game).call
    end

    def initialize(game)
      @solutions = generate_solution_set(game)
      @solutions_cache = @solutions.dup
      @feedback_set = []
    end

    def call
      self
    end

    def reset_game
      @solutions = @solutions_cache.dup
      @feedback_set = []
    end

    def generate_solution_set(game)
      # written to learn how to generate permutations like this recursively.
      permutations(game.valid_tokens, game.sol_pos_count)
    end

    def generate_solution_set2(game)
      # written using ruby permutations method.
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

    def feedback(solution:, guess:)
      unmatched = {
        sol_unmatched: [],
        guess_unmatched: []
      }

      # feedback may be given for each
      # token in the solution set once
      # and only once.
      black_tokens = check_exact_matches(solution, guess, unmatched)
      white_tokens = check_partial_matches(unmatched)
      (['B'] * black_tokens) + (['W'] * white_tokens)
    end

    private

    def check_exact_matches(solution, guess, unmatched)
      black_tokens = 0
      solution.zip(guess) do |sol, guess|
        if sol == guess
          black_tokens += 1
        else
          unmatched[:sol_unmatched] << sol
          unmatched[:guess_unmatched] << guess
        end
      end
      black_tokens
    end

    def check_partial_matches(unmatched)
      white_tokens = 0
      unmatched[:guess_unmatched].each do |guess|
        if (idx = unmatched[:sol_unmatched].index(guess))
          white_tokens += 1
          unmatched[:sol_unmatched].delete_at(idx)
        end
      end
      white_tokens
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
  end
end
