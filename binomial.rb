require_relative 'benchmark'
#  Execution:    ruby binomial.rb N k p
#
#  Reads in N, k, and p as command-line arguments and prints out
#  (N choose k) p^k (1-p)^N-k.
#
#  % ruby binomial.rb 5 2 .25
#  0.263671875
#
#  % ruby binomial.rb 5 3 .25
#  0.087890625
#
#  % ruby binomial.rb 5 0 .25
#  0.2373046875
#
#  % ruby binomial.rb 5 5 .25
#  9.765625E-4

def factor(n)
  n > 1 ? n * factor(n - 1) : 1
end

def choose(n, k)
  factor(n).to_f * factor(k) / factor(n - k)
end

def recursive_binomial(n, k, p)
  return 1 if n == 0 && k == 0
  return 0 if n < 0 || k < 0
  (1 - p) * recursive_binomial(n - 1, k, p) + p * recursive_binomial(n - 1, k - 1, p)
end

def binomial(n, k, p)
  p ** k * (1 - p) ** (n - k) * choose(n, k)
end

start_benchmark do
  p recursive_binomial(25, 13, 0.25)
end

start_benchmark do
  p binomial(120, 60, 0.25)
end
