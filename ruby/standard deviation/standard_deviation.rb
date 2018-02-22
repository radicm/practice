class StandardDeviation

  # REFERENCE for more info visit http://www.mathsisfun.com/data/standard-deviation.html

  # ((x1 - mean)^2 + (x2 - mean)^2 + ... + (xn-mean)^2)
  # ---------------------------------------------------
  #                        n

  # @param [Array][Integer] population
  # @return [Float]
  def self.population_standard_deviation(population)
    mean = mean(population)
    variance = squared_difference(population, mean) / population.size
    Math.sqrt(variance)
  end

  # ((x1 - mean)^2 + (x2 - mean)^2 + ... + (xn-mean)^2)
  # ---------------------------------------------------
  #                      n - 1

  # @param [Array][Integer] sample
  # @return [Float]
  def self.sample_standard_deviation(sample)
    mean = mean(sample)
    variance = squared_difference(sample, mean) / (sample.size - 1)
    Math.sqrt(variance)
  end

  # (x1 + x2 + x3 + xn)
  # -------------------
  #          n

  # @param [Array][Integer] set
  # @param [Integer] set
  def self.mean(set)
    set.inject(&:+) / set.length.to_f
  end

  private

  # (x1 - mean)^2 + (x2 - mean)^2 + ... + (xn - mean)^2

  # @param [Array][Integer] set
  # @param [Integer] mean
  # @return [Integer]
  def self.squared_difference(set, mean)
    set.inject(0) { |acc, x| acc + (x - mean)**2 }
  end

end