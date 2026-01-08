# frozen_string_literal: true

module Mastermind
  # Game methods touching SolutionSpace updating
  # these update potential solutions and feedback
  # for player submitted guesses.
  module GameSols
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
  end
end
