def dailyIntake(caloricValue)
    min(caloricValue, caloricValue.length.times.to_a, 2000)[1]
end

def min(values, indexes, threshold)
    return [threshold, []] if threshold <= 0

    new_indexes = indexes.dup
    i = new_indexes.shift
    new_val = threshold - values[i]
    
    if new_indexes.empty?
        if threshold.abs > new_val.abs
            return [new_val, [i]]
        else
            return [threshold, []]
        end
    end
    
    d1, indexes_1 = min(values, new_indexes, threshold)
    d2, indexes_2 = min(values, new_indexes, new_val)
      
    if d1.abs < d2.abs
        [d1, indexes_1]
    else
        [d2, [i] + indexes_2]
    end
end

def dailyIntake2(caloricValue)
  calories = 2000
  sums = { 0 => '' }

  caloricValue.each_with_index do |calo, index|
    n_sums = {}

    sums.each do |sum, indexes|
      next if sum > calories
    
      n_sum = sum + calo
      n_sums[n_sum] = "#{indexes},#{index.to_s.rjust(2, '0')}"
    end

    n_sums.each do |n_sum, indexes|
      if !sums[n_sum] || sums[n_sum] > indexes
        sums[n_sum] = indexes
      end
    end
  end

  optimal_distance = sums.keys.map { |k| (k - calories).abs }.min

  sums = sums.select do |sum, indexes|
    (sum - calories).abs == optimal_distance
  end

  sums.values.min.split(',').reject(&:empty?).map(&:to_i)
end

p dailyIntake2([
  100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600,
  1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900, 3000
])
