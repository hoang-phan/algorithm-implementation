class RationalNum
  attr_accessor :numerator, :denominator

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
  end

  def simplify
    return @simplify if @simplify
    gcd = Calc.gcd(numerator, denominator)
    @simplify = self.class.new(numerator / gcd, denominator / gcd)
  end

  def reduce_fraction(common)
    self.class.new(numerator * common / denominator, common)
  end

  def inverse
    self.class.new(denominator, numerator).simplify
  end

  def -
    self.class.new(-numerator, denominator)
  end

  def +(other)
    common_denominator = Calc.lcm(denominator, other.denominator)
    self.class.new(
      reduce_fraction(common_denominator).numerator +
        other.reduce_fraction(common_denominator).numerator,
      common_denominator
    ).simplify
  end

  def *(other)
    self.class.new(numerator * other.numerator, denominator * other.denominator).simplify
  end

  def -(other)
    self + (-other)
  end

  def /(other)
    self * other.inverse
  end

  [:==, :>=, :<=, :>, :<].each do |operator|
    define_method operator do |other|
      to_f.public_send(operator, other.to_f)
    end
  end

  def to_s
    denominator == 1 ? numerator.to_s : "#{numerator}/#{denominator}"
  end

  def to_f
    numerator.to_f / denominator
  end
end

class Calc
  def self.gcd(x, y)
    recursive_gcd(*[x, y].sort)
  end

  def self.lcm(x, y)
    x * y / gcd(x, y)
  end

  private

  def self.recursive_gcd(x, y)
    x == 0 ? y : recursive_gcd(y % x, x)
  end
end

rational = RationalNum.new(1, 3) + RationalNum.new(1, 6)

p (rational >= RationalNum.new(2, 3))
