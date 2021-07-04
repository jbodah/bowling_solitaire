module BowlingSolitaire
  class Pin
    attr_reader :value, :idx

    def initialize(idx, value, formation, pin_states: Hash.new { true })
      @idx = idx
      @value = value
      @formation = formation
      @pin_states = pin_states
    end

    def neighbors
      @formation.neighbors_of(@idx)
    end

    def active_walks(upto_length: 3)
      raise unless upto_length == 3
      walks = []
      walks << [self]
      active_neighbors.each do |neighbor|
        walks << [self, neighbor]
        next_neighbors = neighbor.active_neighbors - [self]
        next_neighbors.each do |next_neighbor|
          walks << [self, neighbor, next_neighbor]
        end
      end
      walks
    end

    def active_neighbors
      neighbors.select(&:active?)
    end

    def middle?
      @idx == 4
    end

    def back_row?
      @idx >= 6
    end

    def visited?
      !active?
    end

    def inactive?
      !active?
    end

    def active?
      @pin_states[idx]
    end

    def to_s
      active? ? @value.to_s : 'x'
    end
  end
end
