# frozen_string_literal: true

require "test_helper"

class BowlingSolitaireTest < Minitest::Spec
  describe "Round" do
    # 7 8 9 0
    #  4 5 6
    #   2 3
    #    1
    #
    # 1 2 3 4 5
    # 6 7 8
    # 9 0
    before do
      @round = BowlingSolitaire::Round.new(cards: ((1..9).to_a << 0) * 2)
    end

    it "has 10 pins" do
      assert_equal 10, @round.pins.count
    end

    it "has 3 stacks" do
      assert_equal 3, @round.stacks.count
    end

    it "has a stack of 5, stack of 3, and stack of 2" do
      assert @round.stacks.any? { |s| s.size == 5 }
      assert @round.stacks.any? { |s| s.size == 3 }
      assert @round.stacks.any? { |s| s.size == 2 }
    end

    it "can list all the available top cards" do
      assert_equal [1, 6, 9], @round.top_cards
    end

    # 7 8 9 0
    #  4 5 6
    #   2 3
    #    1
    #
    # 1 2 3 4 5
    # 6 7 8
    # 9 0
    it "has a list of possible moves" do
      expected = [
        [1, [1]],
        [1, [2, 3, 6]],
        [1, [2, 4, 5]],
        [1, [6, 5]],

        [6, [1, 2, 3]],
        [6, [2, 4]],
        [6, [6]],

        [9, [1, 3, 5]],
        [9, [3, 2, 4]],
        [9, [3, 6]],
        [9, [4, 5]]
      ]
      assert_equal BowlingSolitaire::NextBallMove, @round.possible_moves[0].class
      assert_equal expected, @round.possible_moves[1..-1].map { |move| [move.top_card, move.pins.map(&:value)] }
    end

    it "possible moves is based on inactive pins" do
      assert_equal 2, @round.pins[1].value
      round2 = @round.visit_pin(1)

      round3 = round2.mutate { |copy| copy.do_increment_ball_card_number! }
      assert round3.possible_moves[0].is_a? BowlingSolitaire::NextBallMove
      assert_equal [1, 3, 4, 5], round3.possible_moves[1..-1].map(&:pins).map(&:first).map(&:value).uniq.sort
    end

    it "does not allow next ball move if already on second ball" do
      round2 = @round.mutate { |copy| copy.do_increment_ball_number! }
      assert round2.possible_moves.none? { |move| move.is_a? BowlingSolitaire::NextBallMove }
    end

    describe "#mutate" do
      it "do_increment_ball_number!" do
        round2 = @round.mutate { |copy| copy.do_increment_ball_number! }

        assert_equal 2, round2.ball_number
        assert_equal 1, @round.ball_number
      end

      it "do_increment_ball_card_number!" do
        round2 = @round.mutate { |copy| copy.do_increment_ball_card_number! }

        assert_equal 2, round2.ball_card_number
        assert_equal 1, @round.ball_card_number
      end

      it "do_visit_pin!" do
        round2 = @round.mutate { |copy| copy.do_visit_pin!(0) }

        assert round2.pins[0].visited?
        refute @round.pins[0].visited?
      end

      it "do_discard_top!" do
        round2 = @round.mutate { |copy| copy.do_discard_top!(0) }

        assert_equal 4, round2.stacks[0].size
        assert_equal 5, @round.stacks[0].size
      end
    end
  end

  describe "Stack" do
    before do
      @stack = BowlingSolitaire::Stack.new(0, [1, 2, 3])
    end

    it "has a top card" do
      assert_equal 1, @stack.top_card
    end
  end

  describe "PinFormation" do
    # 7 8 9 10
    #  4 5 6
    #   2 3
    #    1
    before do
      @pins = BowlingSolitaire::PinFormation.new((1..10).to_a)
    end

    it "provides access" do
      assert_equal 1, @pins[0].value
    end

    it "properly sets up adjacency" do
      assert_equal [2, 3], @pins[0].neighbors.map(&:value)

      assert_equal [1, 3, 4, 5], @pins[1].neighbors.map(&:value)
      assert_equal [1, 2, 5, 6], @pins[2].neighbors.map(&:value)

      assert_equal [2, 5, 7, 8], @pins[3].neighbors.map(&:value)
      assert_equal [2, 3, 4, 6, 8, 9], @pins[4].neighbors.map(&:value)
      assert_equal [3, 5, 9, 10], @pins[5].neighbors.map(&:value)

      assert_equal [4, 8], @pins[6].neighbors.map(&:value)
      assert_equal [4, 5, 7, 9], @pins[7].neighbors.map(&:value)
      assert_equal [5, 6, 8, 10], @pins[8].neighbors.map(&:value)
      assert_equal [6, 9], @pins[9].neighbors.map(&:value)
    end

    it "can be asked if it is the middle" do
      (0..3).each { |idx| refute @pins[idx].middle? }
      assert @pins[4].value == 5
      assert @pins[4].middle?
      (5..9).each { |idx| refute @pins[idx].middle? }
    end

    it "can be asked if it is in the back row" do
      (0..5).each { |idx| refute @pins[idx].back_row? }
      (6..9).each { |idx| assert @pins[idx].back_row? }
    end

    it "can have pins visited" do
      assert @pins.none?(&:visited?)
      assert @pins.all?(&:active?)
    end
  end

  describe "Assessor" do
    # 7 8 9 0
    #  4 5 6
    #   2 3
    #    1
    it "can determine whether or not a strike is possible" do
      @round = BowlingSolitaire::Round.new(cards: ((1..9).to_a << 0) + [6, 6, 4, 5, 7, 8, 9, 0])
      @assessor = BowlingSolitaire::Assessor.new

      assert @assessor.can_strike?(@round)
    end
  end
end
