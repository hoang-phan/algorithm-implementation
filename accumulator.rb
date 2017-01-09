class Accumulator
  attr_accessor :sample_variant_sqr, :count, :median, :population_variant_sqr

  def initialize
    @count = 0.0
    @median = 0.0
    @sample_variant_sqr = 0.0
    @population_variant_sqr = 0.0
  end

  def <<(number)
    # n++
    @count += 1

    delta = number - median
    new_median = median + delta / count

    # s(n)^2 = (n-2)s(n-1)^2 / (n-1) + (x - m(n - 1)) ^ 2 / n 
    @sample_variant_sqr =
      if count > 1
        sample_variant_sqr * (count - 2) / (count - 1) + delta ** 2 / count
      else
        0
      end
    # o(n)^2 = ((n - 1) o(n - 1)^2 + (x - m(n - 1))(x - m(n))) / n
    @population_variant_sqr = ((count - 1) * population_variant_sqr + delta * (number - new_median)) / count

    # m(n) = m(n - 1) + (x - m(n-1)) / n
    @median = new_median
  end
end

acc = Accumulator.new
acc << 1
acc << 2
acc << 3

p acc.count
p acc.median
p acc.sample_variant_sqr
p acc.population_variant_sqr
