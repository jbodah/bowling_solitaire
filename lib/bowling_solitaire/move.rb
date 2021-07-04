module BowlingSolitaire
  class Move
    def before
      @round.preview
    end

    def after
      apply.preview
    end

    def preview
      before
      puts "-->"
      after
    end
  end
end

