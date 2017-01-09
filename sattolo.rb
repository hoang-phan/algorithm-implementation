def sattolo(arr)
  n = arr.length
  (n - 1).downto(0).each do |index|
    new_index = rand(n)
    swap = arr[index]
    arr[index] = arr[new_index]
    arr[new_index] = swap
  end
  arr
end

p sattolo([1, 3, 2, 55, 22, 21])
