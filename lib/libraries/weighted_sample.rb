require 'json'

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
      total = 0

      # puts self.to_json
      # puts weights.to_json
      # debugger if length > 3

      weights.each do |weight|
        if weight == 0
          nil
        else
          total += weight
        end
      end

      # puts weights.to_json

      choice = rand(0..total)

      # puts "#{choice}/#{total}"

      weights.each.with_index do |chance, i|
        next if chance.nil?

        choice -= chance

        # puts "#{i}: #{choice} < #{chance} out of #{total}"

        # puts i if choice <= 0
        return self[i] if choice <= 0
      end
    end
  end
end
