# frozen_string_literal: true

module Mastermind
  # display messages to the console during play
  module GameMsgs
    GAME_SET_HEADER = <<~GSHEADER
      =========================================================================
      =========================================================================
      Start new set - player roles will reverse between matches.
      Playing set %<cur_set>d of %<total_sets>d
      =========================================================================
      =========================================================================

    GSHEADER

    GAME_SET_FOOTER = <<~GSFOOTER
      =========================================================================
      GAME OVER:

        Player scores:
          %<codemakername>s score: %<codemakerscore>s
          %<codebreakername>s score: %<codebreakerscore>s

    GSFOOTER

    GAME_SETS = <<~GAMESETS
      ====================  PLAYING MASTERMIND !!!=============================
      Game parameters are set as follows:
        Positions: %<positions>s
           Tokens: %<tokens>s
          Guesses: %<guesses>s

      How many sets shall we play?

      1 set = 2 matches, players reverse roles between matches.

    GAMESETS

    MATCH_BANNER = <<~MBANNER
      =========================================================
      New Match:
      =========================================================

    MBANNER

    MASTERMIND_HELP = <<~MHELP
      =========================================================================
      Mastermind takes 3 options parameters from the command line to modify
      gameplay.

      ./run.sh [positions:n] [choices:n] [guesses:n]

        positions = number of positions in the secret code (default = 4)
          choices = distinct tokens for each position (default = 6)
          guesses = number of guesses the codebreaker has available
                    to guess the secret code (default = 12)

      example:

      ./run.sh 'positions:3' 'choices:5' 'guesses:10'
      ./run.sh 'positions:3'

      Default values are assumed for all missing parameters.

      ./run.sh --help displays this message.

      =========================================================================
    MHELP

    GET_PLAYER_NAME = <<~GETPNAME
      ---------------------------------------------------------
      Enter player %<num>d name: (press enter for computer play)
      ---------------------------------------------------------
    GETPNAME

    PLAYER_ROLES = <<~PROLES
      Player roles are assigned as follows:

        CODEMAKER: %<codemakername>s (score: %<codemakerscore>s)
      CODEBREAKER: %<codebreakername>s (score: %<codebreakerscore>s)
      =========================================================
    PROLES

    PLAYER_SCORES = <<~PSCORES
        CODEMAKER: %<codemakername>s score: %<codemakerscore>s
      CODEBREAKER: %<codebreakername>s score: %<codebreakerscore>s

    PSCORES

    SETCODE_MSG = <<~SETCODEMSG

      CODEMAKER: (%<codemakername>s): Select a code:
    SETCODEMSG

    CODE_HELPMSG = <<~CODEHELPMSG
      ---------------------------------------------------------
      The secret code contains exactly %<num_positions>d positions/characters.
      There are %<num_tokens>d tokens per position from which to choose
      Valid values for each token range from "%<first_token>s" to "%<last_token>s".

      The code is not case sensitive, "A" is equivalent to "a".
      The code guesser will have %<guess_count>d guesses to guess the code.
      ---------------------------------------------------------

    CODEHELPMSG

    GUESS_HEADING = <<~GUESSHEADING
      =========================================================
        Guess: %<cur_guess_count>d of %<guess_count>d
        CODEBREAKER: (%<codebreakername>s)
      =========================================================

    GUESSHEADING

    GUESS_FEEDBACK = <<~GUESSFEEDBACK
      ---------------------------------------------------------
      Feedback:
      Guess = %<codeguess>s
      %<b_tokencount>d tokens correct and in correct position
      %<w_tokencount>d tokens correct but in wrong position

    GUESSFEEDBACK

    CORRECT_GUESS = <<~CORRECTGUESS
      YOU WIN!!
      You cracked the code in %<cur_guess_count>d guesses.
        The code was: %<solution>s

    CORRECTGUESS

    MATCH_LOSS = <<~MATCHLOSS
      YOU LOSE.
      The code was: %<solution>s

    MATCHLOSS
    def print_game_set_header(game)
      print format(GAME_SET_HEADER, cur_set: game.cur_set,
                                    total_sets: game.game_sets)
    end

    def print_game_set_footer(game)
      puts format(GAME_SET_FOOTER, codemakername: game.players[:codemaker].player_name,
                                   codebreakername: game.players[:codebreaker].player_name,
                                   codemakerscore: game.players[:codemaker].player_score,
                                   codebreakerscore: game.players[:codebreaker].player_score)
    end

    def print_game_set_message(game)
      print format(GAME_SETS, positions: game.sol_pos_count,
                              tokens: game.token_choice_count,
                              guesses: game.sol_guess_count)
    end

    def print_match_banner
      puts Mastermind::GameMsgs::MATCH_BANNER
    end

    def print_get_player_name(i)
      print format(GET_PLAYER_NAME, num: i)
    end

    def print_code_help_msg(game)
      puts format(CODE_HELPMSG, num_positions: game.sol_pos_count,
                                num_tokens: game.token_choice_count,
                                first_token: game.valid_tokens[0],
                                last_token: game.valid_tokens[-1],
                                guess_count: game.sol_guess_count)
    end

    def print_player_roles(game)
      puts format(PLAYER_ROLES, codemakername: game.players[:codemaker].player_name,
                                codebreakername: game.players[:codebreaker].player_name,
                                codemakerscore: game.players[:codemaker].player_score,
                                codebreakerscore: game.players[:codebreaker].player_score)
    end

    def print_player_scores(game)
      puts format(PLAYER_SCORES, codemakername: game.players[:codemaker].player_name,
                                 codebreakername: game.players[:codebreaker].player_name,
                                 codemakerscore: game.players[:codemaker].player_score,
                                 codebreakerscore: game.players[:codebreaker].player_score)
    end

    def print_setcode_heading(game)
      puts format(SETCODE_MSG, codemakername: game.players[:codemaker].player_name)
    end

    def print_guess_heading(game)
      puts format(GUESS_HEADING, codebreakername: game.players[:codebreaker].player_name,
                                 cur_guess_count: game.codebreaker_guess_count,
                                 guess_count: game.sol_guess_count)
    end

    def print_guess_feedback(game)
      puts format(GUESS_FEEDBACK, codeguess: game.codebreaker_guess.join,
                                  b_tokencount: game.codebreaker_guess_feedback.count('B'),
                                  w_tokencount: game.codebreaker_guess_feedback.count('W'))

      # match end message is only printed if codebreaker wins or loses.
      return print_winning_msg(game) if game.codebreaker_wins?
      return print_losing_msg(game) if game.codebreaker_loses? # rubocop:disable Style/RedundantReturn
    end

    def print_winning_msg(game)
      puts format(CORRECT_GUESS, cur_guess_count: game.codebreaker_guess_count,
                                 solution: game.solution.join)
    end

    def print_losing_msg(game)
      puts format(MATCH_LOSS, solution: game.solution.join)
    end
  end
end
