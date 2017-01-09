def solution1
  (1..100).map do |x|
    if x % 15 == 0
      'WizeLine'
    elsif x % 3 == 0
      'Wize'
    elsif x % 5 == 0
      'Line'
    else
      x
    end
  end
end

p solution1

def solution2(arr)
  arr.sort_by(&:abs)
end

p solution2([2, -12, 0, 7, 0, -99])
