require_relative 'benchmark'

@points = []

VIEWPORT_X = 100
VIEWPORT_Y = 200

def random_points(num_points, viewport_x, viewport_y)
  num_points.times.map do |i|
    [rand(viewport_x), rand(viewport_y)]
  end
end

def sqr_distance(point_1, point_2)
  (point_1[0] - point_2[0]) ** 2 + (point_1[1] - point_2[1]) ** 2
end

def min_sqr_distance(num_points)
  points = random_points(num_points, VIEWPORT_X, VIEWPORT_Y)

  min_sqr_distance = VIEWPORT_X ** 2 + VIEWPORT_Y ** 2
  
  num_points.times do |i|
    ((i + 1)..(num_points - 1)).each do |j|
      sqr_distance = sqr_distance(points[i], points[j])
      min_sqr_distance = sqr_distance if sqr_distance < min_sqr_distance
    end
  end

  min_sqr_distance
end

def min_sqr_distance_enhanced(num_points)
  recursive_min_distance
end

start_benchmark { p min_sqr_distance(ARGV[0].to_i) }

