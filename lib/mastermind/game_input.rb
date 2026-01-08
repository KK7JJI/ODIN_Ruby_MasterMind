# frozen_string_literal: true

module Mastermind
  # methods used to validate player input codes
  module GameInput
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
      return false unless sol.length == sol_pos_count
      return false unless sol.all? { |chr| valid_tokens.include?(chr) }

      true
    end
  end
end
