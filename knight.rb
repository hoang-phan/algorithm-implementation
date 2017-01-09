require 'json'
require_relative './benchmark'

STEPS = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]

class Sample
  MATRIX_SIZE = 100
  START = MATRIX_SIZE / 2
  MAX_STEP = MATRIX_SIZE / 4

  attr_accessor :matrix, :queue

  def initialize
    @matrix = JSON(([[nil] * MATRIX_SIZE] * MATRIX_SIZE).to_json)
    @queue = [[START, START, 0]]
    @matrix[START][START] = -1
  end

  def solve
    bfs
  end

  private

  def bfs
    node = queue.pop
    
    return unless node

    x, y, min = node
    matrix[x][y] = min

    minn = min + 1

    return if minn >= MAX_STEP

    STEPS.each do |(dx, dy)|
      xn = x + dx
      yn = y + dy

      if matrix[xn][yn].nil?
        queue.unshift [xn, yn, minn]
        matrix[xn][yn] = -1
      end
    end

    bfs
  end
end

class Knight
  attr_accessor :all_comparison

  PRECISION = 4

  def initialize
    @all_comparison = []
  end

  def solve(x, y)
    result = qsolve(x, y)
    return result if result

    solve_children(1, x, y)

    all_comparison.min
  end

  def solve_children(level, x, y)
    new_level = level + 1
    
    STEPS.each do |(dx, dy)|
      x1 = x + dx
      y1 = y + dy
      result = qsolve(x1, y1)
      all_comparison << result + level if result
      
      solve_children(new_level, x1, y1) if level <= PRECISION
    end
  end

  def qsolve(x, y)
    i = x.abs
    j = y.abs
    i, j = [i, j].sort

    if j % 2 == 0 && i % 2 == j / 2 % 2 && i * 2 <= j
      j / 2
    elsif i == j && i % 3 == 0
      j * 2 / 3
    end
  end
end

class Test
  attr_accessor :passed, :failed

  def initialize
    @passed = 0
    @failed = 0
  end

  def assert_equals(a, b)
    if a == b
      p 'Passed!'
      @passed += 1
    else
      if b
        p "Failed. Expected #{a} got #{b}"
      else
        p "Not implemented"
      end
      @failed += 1
    end
  end
end

samples = Sample.new

start_benchmark do
  samples.solve
end

test = Test.new

res = ''

start_benchmark do
  30.times do |i|
    30.times do |j|
      test.assert_equals(samples.matrix[i + Sample::START][j + Sample::START], Knight.new.solve(i, j))
    end
  end
end

p "Test completed. #{test.passed} passed, #{test.failed} failed!"
