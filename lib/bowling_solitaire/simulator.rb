module BowlingSolitaire
  class Simulator
    def initialize(n)
      @n = n
    end

    def run
      results = []
      assessor = Assessor.new
      @n.times do
        round = Round.new
        if assessor.can_strike?(round)
          results << :strike
        elsif assessor.can_spare?(round)
          results << :spare
        else
          results << assessor.best_score(round)
        end
      end
      out = {}
      out[:strikes] = results.count { |x| x == :strike } / @n.to_f
      out[:spares] = results.count { |x| x == :spare } / @n.to_f
      (0..9).to_a.each do |n|
        out[n] = results.count { |x| x == n } / @n.to_f
      end
      out
    end
  end
end

