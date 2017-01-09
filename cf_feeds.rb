def feedOptimizer(span, h, events)
    result = []
    stories = []
    story_index = 1
    
    events.each do |event|
        while stories.first && stories.first[0] + span < event[0]
            stories.shift
        end
        
        if event.length == 1
            heights_map = { 0 => [0, '']}
            
            stories.each do |(timestamp, score, height, index)|
                new_heights_map = {}

                heights_map.each do |t_h, (t_s, els)|
                    new_t_h = height + t_h
                    next if new_t_h > h 
                    new_heights_map[new_t_h] = [score + t_s, els + ",#{index.to_s.rjust(3, '0')}"]
                end

                new_heights_map.each do |t_h, (t_s, els)|
                    old = heights_map[t_h]

                    if !old || t_s > old[0] ||
                        t_s == old[0] && els.length < old[1].length ||
                        t_s == old[0] && els.length == old[1].length && els < old[1]
                        heights_map[t_h] = [t_s, els]
                    end
                end
            end

            displays = heights_map.values.sort_by(&:first).last
            result << [displays[0], displays[1].split(',').map(&:to_i)]
        else
            stories << event + [story_index]
            story_index += 1
        end
    end

    result
end

p feedOptimizer(10, 100, [[11, 50, 30], [12], [13, 40, 20], [14, 45, 40], [15], [16], [18, 45, 20], [21], [22]])
