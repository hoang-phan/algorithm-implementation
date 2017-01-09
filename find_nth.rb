class FindNth
  attr_accessor :array, :length

  def initialize(array)
    @array = array
    @length = array.length
  end

  def exec(n)
    build_heap
    n.times { pop }
    array[0]
  end

  private

  def build_heap
    (length / 2 - 1).downto(0).each do |index|
      heapify(index)
    end
  end

  def pop
    result = array[0]

    array[0] = array.pop
    @length = array.length
    
    heapify(0)
    result
  end

  def heapify(index)
    left_index = 2 * index + 1
    right_index = left_index + 1

    return if left_index >= length

    swap_index = left_index

    if array[right_index] && array[right_index] > array[swap_index]
      swap_index = right_index
    end

    if array[swap_index] > array[index]
      swap(index, swap_index)
      heapify(swap_index)
    end
  end

  def swap(i, j)
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
  end
end

arr = 10000.times.map { rand }
reverse_sort = arr.sort.reverse

p arr.length.times.all? do |i|
  reverse_sort[i] == FindNth.new(arr.dup).exec(i)
end
