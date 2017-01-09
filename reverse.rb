require_relative 'benchmark'

def reverse(str)
  n = str.length
  n > 1 ? reverse(str[n / 2..-1]) + reverse(str[0..n / 2 - 1]): str 
end

p reverse(ARGV[0])
