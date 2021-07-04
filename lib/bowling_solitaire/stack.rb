require "forwardable"

module BowlingSolitaire
  class Stack
    extend Forwardable

    attr_reader :cards

    def initialize(idx, cards)
      @idx = idx
      @cards = cards
    end

    def_delegator :@cards, :size

    def top_card
      @cards[0]
    end
  end
end
