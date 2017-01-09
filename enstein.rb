FACTS = [
  ['Brit', 'red'],
  ['Swede', 'dogs'],
  ['Dane', 'tea'],
  ['green', 'coffee'],
  ['PallMall', 'birds'],
  ['yellow', 'Dunhill'],
  [2, 'milk'],
  [0, 'Norwegian'],
  ['BlueMaster', 'beer'],
  ['German', 'Prince'],
  [1, 'blue']
]

POOLS = 5.times.flat_map do |house_pos|
  %w(Brit Swede Dane Norwegian German).flat_map do |nationality|
    %w(red green white blue yellow).flat_map do |color|
      %w(PallMall Dunhill Blends Prince BlueMaster).flat_map do |cigar|
        %w(tea coffee milk water beer).flat_map do |bever|
          %w(dogs cats birds horses fish).map do |pet|
            [house_pos, nationality, color, cigar, bever, pet]
          end
        end
      end
    end
  end
end

def riddle
  pools = POOLS.select do |pool|
    FACTS.all? { |fact| (fact - pool).empty? || fact - pool == fact }
  end.group_by(&:first)

  results = []

  pools[0].each do |pool_0|
    pools[1].each do |pool_1|
      next unless uniq?(pools_1 = pool_0 + pool_1)

      pools[2].each do |pool_2|
        next unless uniq?(pools_2 = pools_1 + pool_2)

        pools[3].each do |pool_3|
          next unless uniq?(pools_3 = pools_2 + pool_3)

          pools[4].each do |pool_4|
            results << pools_4 if uniq?(pools_4 = pools_3 + pool_4)
          end
        end
      end
    end
  end

  results.select! { |res| res.index('green') / 6 - res.index('white') / 6 == -1 }
  results.select! { |res| (res.index('Blends') / 6 - res.index('cats') / 6).abs == 1 }
  results.select! { |res| (res.index('horses') / 6 - res.index('Dunhill') / 6).abs == 1 }
  results.select! { |res| (res.index('Blends') / 6 - res.index('water') / 6).abs == 1 }

  results.map { |res| res[res.index('fish') - 4] }.uniq
end

def uniq?(lst)
  lst.uniq.count == lst.count
end
