module BowlingSolitaire
  class Round
    CARDS = (0..9).to_a * 2

    attr_reader :pins, :stacks, :ball_card_number, :ball_number

    def initialize(cards: CARDS.shuffle, pin_states: Hash.new { true }, ball_number: 1, ball_card_number: 1)
      @cards = cards
      @__pin_states = pin_states
      @pins = PinFormation.new(cards[0..9], pin_states: @__pin_states)
      @stacks = [
        Stack.new(0, cards[10..14]),
        Stack.new(1, cards[15..17]),
        Stack.new(2, cards[18..19])
      ]
      @ball_card_number = ball_card_number
      @ball_number = ball_number
    end

    def __pin_states
      @__pin_states
    end

    def possible_moves
      moves = []
      moves << NextBallMove.new(self) if @ball_number == 1
      use_ball_moves = []
      @stacks.each_with_index do |stack, stack_idx|
        top_card = stack.top_card
        next if top_card.nil?
        possible_start_pins.each do |pin|
          pin.active_walks(upto_length: 3).each do |walk|
            if walk.map(&:value).sum % 10 == top_card
              move = UseBallCardMove.new(self, stack_idx, walk.map(&:idx))
              use_ball_moves << move if valid_move?(move)
            end
          end
        end
      end
      moves + use_ball_moves.uniq { |move| move.pins_sorted }
    end

    def possible_start_pins
      start_pins = active_pins_with_inactive_neighbors
      start_pins.any? ? start_pins : outer_pins
    end

    def outer_pins
      [0, 1, 2, 3, 5].map { |pin_idx| @pins[pin_idx] }
    end

    def active_pins_with_inactive_neighbors
      @pins.select { |pin| pin.active? && pin.neighbors.any?(&:inactive?) }
    end

    def valid_move?(move)
      if @ball_card_number == 1
        return false if move.start_pin.middle? || move.pins.any?(&:back_row?)
      end

      true
    end

    def top_cards
      @stacks.map(&:top_card)
    end

    def visit_pin(idx)
      mutate { |copy| copy.do_visit_pin!(idx) }
    end

    def do_visit_pin!(idx)
      @__pin_states[idx] = false
    end

    def do_discard_top!(idx)
      @stacks[idx] = Stack.new(idx, @stacks[idx].cards[1..-1])
    end

    def do_increment_ball_number!
      @ball_number += 1
    end

    def do_increment_ball_card_number!
      @ball_card_number += 1
    end

    def mutate(&blk)
      Round.new(cards: @cards, pin_states: __pin_states.dup, ball_number: ball_number, ball_card_number: ball_card_number).tap do |copy|
        blk.call copy
      end
    end

    def done_success?
      score == 10
    end

    def score
      pins.count(&:inactive?)
    end

    def preview
      puts <<-EOF
      #{pins[6]} #{pins[7]} #{pins[8]} #{pins[9]}
       #{pins[3]} #{pins[4]} #{pins[5]}
        #{pins[1]} #{pins[2]}
         #{pins[0]}
      EOF
    end
  end
end
