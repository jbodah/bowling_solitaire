module BowlingSolitaire
  class UseBallCardMove < Move
    def initialize(round, stack_idx, pin_idxs)
      @round = round
      @stack_idx = stack_idx
      @pin_idxs = pin_idxs
    end

    def apply
      @apply ||= @round.mutate do |copy|
        copy.do_discard_top!(@stack_idx)
        copy.do_increment_ball_card_number!
        @pin_idxs.each do |idx|
          copy.do_visit_pin!(idx)
        end
      end
    end

    def pins
      @pins ||= @pin_idxs.map { |idx| @round.pins[idx] }
    end

    def start_pin
      @round.pins[@pin_idxs[0]]
    end

    def top_card
      @round.stacks[@stack_idx].top_card
    end

    def eql?(other)
      pins_sorted == other.pins_sorted
    end

    def hash
      pins_sorted.hash
    end

    def pins_sorted
      @pins_sorted ||= pins.sort_by(&:idx)
    end
  end
end
