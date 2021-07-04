module BowlingSolitaire
  class Assessor
    def can_strike?(round)
      dfs(only_try_to_strike(round.possible_moves)) do |move|
        next_round = move.apply
        return true if next_round.done_success?
        only_try_to_strike(next_round.possible_moves)
      end
      false
    end

    def can_spare?(round)
      dfs(round.possible_moves) do |move|
        next_round = move.apply
        return true if next_round.done_success?
        next_round.possible_moves
      end
      false
    end

    def best_score(round)
      best_score = 0
      dfs(round.possible_moves) do |move|
        next_round = move.apply
        if next_round.possible_moves.none?
          if next_round.score > best_score
            best_score = next_round.score
            # NOTE: @jbodah 2021-07-03: we don't assume a perfect score is possible so early exit if score is 9
            break if best_score == 9
          end
        end
        next_round.possible_moves
      end
      best_score
    end

    private

    def dfs(init)
      queue = init
      until queue.empty?
        hd, *tail = queue
        children = yield hd
        queue = children + tail
      end
    end

    def only_try_to_strike(moves)
      moves.reject { |move| move.is_a? NextBallMove }
    end
  end
end
