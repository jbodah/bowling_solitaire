module BowlingSolitaire
  class NextBallMove < Move
    def initialize(round)
      @round = round
    end

    def apply
      @apply ||= @round.mutate { |copy| copy.do_increment_ball_number! }
    end
  end
end
