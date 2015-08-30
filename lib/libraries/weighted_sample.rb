class Array
  def weighted_sample
    l = self.length * 2
    self[ (((rand(l) + rand(l) + rand(l) + rand(l)))/4 - self.length).abs ]
  end
end
