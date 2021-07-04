require "forwardable"

module BowlingSolitaire
  class PinFormation
    include Enumerable
    extend Forwardable

    def initialize(cards, pin_states: Hash.new { true })
      @pins = cards.each_with_index.map { |val, idx| Pin.new(idx, val, self, pin_states: pin_states) }
    end

    def_delegator :@pins, :each

    def [](idx)
      @pins[idx]
    end

    def neighbors_of(idx)
      case idx
      when 0
        cards_at 1, 2
      when 1
        cards_at 0, 2, 3, 4
      when 2
        cards_at 0, 1, 4, 5
      when 3
        cards_at 1, 4, 6, 7
      when 4
        cards_at 1, 2, 3, 5, 7, 8
      when 5
        cards_at 2, 4, 8, 9
      when 6
        cards_at 3, 7
      when 7
        cards_at 3, 4, 6, 8
      when 8
        cards_at 4, 5, 7, 9
      when 9
        cards_at 5, 8
      else
        raise
      end
    end

    private

    def cards_at(*idxs)
      idxs.map { |idx| self[idx] }
    end
  end
end
