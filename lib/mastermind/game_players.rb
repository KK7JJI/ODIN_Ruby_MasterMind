# frozen_string_literal: true

module Mastermind
  # Game methods managing players
  module GamePlayers
    def save_player_info(player)
      return save_player(player, :codebreaker) if players[:codebreaker].nil?
      return save_player(player, :codemaker) if players[:codemaker].nil?

      'Invalid: this is a two player game.'
    end

    def save_player(player_obj, player_role)
      player_obj.game = self
      players[player_role.to_sym] = player_obj
      "#{player_obj.player_name} is the #{player_role}"
    end

    def reverse_player_roles
      temp = players[:codemaker]
      players[:codemaker] = players[:codebreaker]
      players[:codebreaker] = temp
    end

    def update_player_score
      players[:codebreaker].player_score += 1 unless codebreaker_loses?
    end

    def codebreaker_wins?
      return true if codebreaker_guess_feedback.all?('B') &&
                     (codebreaker_guess_feedback.length == sol_pos_count)

      false
    end

    def codebreaker_loses?
      return true if codebreaker_guess_count > sol_guess_count

      false
    end
  end
end
