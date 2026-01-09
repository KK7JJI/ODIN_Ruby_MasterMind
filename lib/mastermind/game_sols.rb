# frozen_string_literal: true

module Mastermind
  # Game methods touching SolutionSpace updating
  # these update potential solutions and feedback
  # for player submitted guesses.
  module GameSols
    def sample_solution_space
      minmax_data.solutions.sample
    end

    def calculate_codebreaker_guess_feedback
      self.codebreaker_guess_feedback =
        minmax_data.feedback(solution: solution, guess: codebreaker_guess)
    end

    def update_sol_feedback_set
      minmax_data.generate_feedback_set(guess: codebreaker_guess)
    end

    def update_solution_space
      minmax_data.update_solution_set(feedback: codebreaker_guess_feedback)
    end

    def possible_solution_count
      minmax_data.solutions.length
    end
  end
end
