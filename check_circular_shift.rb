require_relative 'benchmark'

def circular_shifted?(str1, str2)
  str1.length == str2.length && (str2 * 2).include?(str1)
end

p circular_shifted?('ABCD', 'DABC')
p circular_shifted?('ABCD', 'ADBC')
