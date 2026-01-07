# frozen_string_literal: true

module Mastermind
  # main program entry point.
  class App
    def run(args)
      mastermind = Mastermind::Game.call(
        sol_pos_count: 4,
        sol_guess_count: 12,
        token_choice_count: 6
      )

      puts mastermind.save_player_info(ComputerPlayerMinMax.call(player_name: 'Player 1'))
      puts mastermind.save_player_info(ComputerPlayerMinMax.call(player_name: 'Player 2'))

      2.times do
        mastermind.print_player_roles
        mastermind.print_player_scores

        mastermind.display_setcode_heading
        mastermind.players[:codemaker].submit_solution

        until mastermind.game_over?
          mastermind.display_guess_heading
          mastermind.players[:codebreaker].submit_codebreaker_guess
          mastermind.display_guess_feedback
          mastermind.update_sol_feedback_set
          mastermind.update_solution_space
        end

        puts ''
        puts '======================'
        puts 'Switching player roles'
        puts '======================'
        puts ''
        mastermind.reverse_player_roles
        mastermind.reset_game
      end
    end
  end
end
