class CustomQueue
  attr_accessor :items

  def initialize
    @items = []
  end

  def <<(item)
    items << item
  end

  def pop
    items.shift
  end

  def to_a
    items
  end
end

SIZE = 21

class BreathFirstSearchKnight
  POSSIBLE_MOVES = [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [2, -1], [-2, -1], [-2, 1]]

  attr_accessor :matrix, :queue

  def initialize
    @matrix = SIZE.times.map { [] }
    @queue = CustomQueue.new
    queue << [SIZE / 2, SIZE / 2, 0]
  end

  def traverse
    while (node = queue.pop)
      matrix[node[0]][node[1]] = node[2]
      p "At node: [#{node[0]}, #{node[1]}] = #{node[2]}"
      p "Queue: #{queue.to_a}"

      POSSIBLE_MOVES.each do |(x, y)|
        new_x = node[0] + x
        new_y = node[1] + y

        if new_x.between?(0, SIZE - 1) && new_y.between?(0, SIZE - 1) && matrix[new_x][new_y].nil?
          p "Added node [#{new_x}, #{new_y}]"
          queue << [new_x, new_y, node[2] + 1]
          matrix[new_x][new_y] = -1
        end
      end
    end
  end
end

bfs = BreathFirstSearchKnight.new
bfs.traverse

(SIZE / 2.. SIZE - 1).each do |x|
  display_row = ''
  
  (SIZE / 2.. SIZE - 1).each do |y|
    display_row += ' ' + (bfs.matrix[x][y] ? bfs.matrix[x][y].to_s.rjust(1, '0') : 'NA')
  end

  p display_row.strip
end
