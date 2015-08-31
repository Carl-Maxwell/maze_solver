class Array
  def weighted_sample
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
  end
end
