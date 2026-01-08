# frozen_string_literal: true

module Mastermind
  # main program entry point.
  class App
    include Mastermind::GameMsgs
    include Mastermind::Init

    def run(args)
      return print_game_help unless valid_args?(args)
      return print_game_help if print_game_help?(args)

      parms = game_args(args)
      mastermind = Mastermind::Game.call(
        sol_pos_count: parms[:positions], sol_guess_count: parms[:guesses],
        token_choice_count: parms[:choices]
      )
      sets_to_be_played(game: mastermind)
      save_players(game: mastermind)
      play_sets(game: mastermind)
    end

    def sets_to_be_played(game:)
      print_game_set_message(game)
      until game.game_sets.positive?
        puts 'Choose a number > 0.'
        print 'SETS: '
        game.game_sets = $stdin.gets.chomp.to_i
      end
    end

    def save_players(game:)
      i = 0
      2.times do
        i += 1
        print_get_player_name(i)
        print 'NAME:'
        p_name = $stdin.gets.chomp
        save_computer_player(game, name: "Player #{i}") if p_name.empty?
        save_human_player(game, name: p_name) unless p_name.empty?
      end
    end

    def save_computer_player(game, name:)
      game.save_player_info(ComputerPlayerMinMax.call(player_name: name))
      puts ''
      puts "NOTE: #{name} is a computer player."
      puts ''
    end

    def save_human_player(game, name:)
      game.save_player_info(HumanPlayer.call(player_name: name))
      puts ''
      puts "NOTE: #{name} is a human player."
      puts ''
    end

    def play_sets(game:)
      (1..game.game_sets).each do
        game.cur_set += 1
        print_game_set_header(game)
        2.times do
          reset_match(game)
          play_match(game)
        end
      end
      print_game_set_footer(game)
    end

    def play_match(game)
      print_match_header(game)
      game.players[:codemaker].submit_solution

      until game.game_over?
        print_guess_heading(game)
        game.players[:codebreaker].submit_codebreaker_guess
        print_guess_feedback(game)
        game.update_sol_feedback_set
        game.update_solution_space
      end
      game.update_player_score
    end

    def print_match_header(game)
      print_player_roles(game)
      print_setcode_heading(game)
    end

    def reset_match(game)
      game.reverse_player_roles
      game.reset_game
    end
  end
end
