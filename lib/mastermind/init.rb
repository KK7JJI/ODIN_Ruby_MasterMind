# frozen_string_literal: true

module Mastermind
  # used to initiate a new game of mastermind
  # methods used in app.rb
  module Init
    VALID_NAMES = %i[positions choices guesses].freeze
    DEFAULT_PARMS = {
      positions: 4,
      choices: 6,
      guesses: 12
    }.freeze

    private

    def valid_args?(args)
      return true if args[0] == '--help'
      return true if args.empty?
      return false unless args.all? do |arg|
        VALID_NAMES.include?(resolve_name_value_pair(arg)[0])
      end
      return false unless args.all? do |arg|
        resolve_name_value_pair(arg)[1].to_i.positive?
      end

      true
    end

    def print_game_help?(args)
      return true if args[0] == '--help'

      false
    end

    def print_game_help
      puts GameMsgs::MASTERMIND_HELP
    end

    def game_args(args)
      parms = {}
      args.each do |arg|
        pair = resolve_name_value_pair(arg)
        parms[pair[0]] = pair[1].to_i
      end
      fill_in_missing_parms(parms)
      parms
    end

    def fill_in_missing_parms(parms)
      (DEFAULT_PARMS.keys - parms.keys).each do |key|
        parms[key] = DEFAULT_PARMS[key]
      end
    end

    def resolve_name_value_pair(arg)
      pair = arg.split(':')
      pair[0] = pair[0].to_sym
      pair
    end
  end
end
