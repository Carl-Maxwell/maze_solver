class Array
  def weighted_sample(weights = nil)
    if !weights
      l = self.length * 2

      divisor = 4

      thing = 0

      divisor.times { thing += rand(l) }

      thing /= divisor

      thing -= self.length

      if thing < 0
        thing = thing.abs() - 1
      end

      self[ thing ]
    else
      raise 'Error! Weighted sample does not take an argument (yet)'

      total = 0
      weights.map! do |weight|
        total += weight
      end

      puts weights

      choice = rand(total)

      puts choice

      weights.each.with_index do |thing, i|
        return self[i] if choice <= thing

        choice -= thing
      end
    end
  end
end
