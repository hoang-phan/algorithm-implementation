def backupTimeEstimator(startTimes, backupDuration, maxThreads)
    last_time = nil
    threads = []
    queue = []
    end_time = {}
    
    timelines = startTimes.each_with_index.map do |time, index|
        [time, :start, index]
    end

    completed = startTimes.count.times.each_with_object({}) do |index, result|
        result[index] = [0, 1]
    end

    while !timelines.empty?
        p "Timeline: #{timelines}"
        time, event, ei = timelines.shift
        p "Time: #{time}. Event: #{event}. Job index: #{ei}"
        if last_time
            threads.each do |i|
                completed[i] = add(
                    completed[i],
                    [time - last_time, backupDuration[i] * threads.count]
                )
            end
        end
        p "Threads: #{threads}"
        p "Completed: #{completed}"
        p "Queue: #{queue}"
        
        last_time = time
        
        if event == :finish
            end_time[ei] = time
            threads -= [ei]
            unless queue.empty?
              next_job = queue.shift
              next_job = [time] + next_job
              timelines.unshift(next_job)
            end
            timelines = modifyTimelines(time, timelines, backupDuration, completed, threads.count)
            timelines.sort_by!(&:first)
        elsif threads.count < maxThreads
            timelines = modifyTimelines(time, timelines, backupDuration, completed, threads.count + 1)

            threads << ei
            timelines <<
                [time + backupDuration[ei] * threads.count, :finish, ei]
            timelines.sort_by!(&:first)
        else
            queue << [event, ei]
        end
        p ""
        p ""
        p ""
    end
    
    end_time.sort_by(&:first).map(&:last)
end

def modifyTimelines(time, timelines, backupDuration, completed, threads_count)
    timelines.count.times do |i|
        t = timelines[i]
        if t[0] > time && t[1] == :finish
            old = t[0]
            timelines[i][0] = time +
                to_f(multiply(
                    minus(1, completed[t[2]]),
                    backupDuration[t[2]] * threads_count
                ))
            p "Modify finish time of #{t[2]} from #{old} to #{timelines[i][0]}"
        end
    end
    timelines
end

def add(ratio1, ratio2)
    if ratio1.is_a? Fixnum
        ratio1 = [ratio1, 1]
    end
    simplify [ratio1[0] * ratio2[1] + ratio1[1] * ratio2[0], ratio1[1] * ratio2[1]]
end

def minus(ratio1, ratio2)
    add(ratio1, [-ratio2[0], ratio2[1]])
end

def multiply(ratio, n)
    simplify [ratio[0] * n, ratio[1]]
end

def to_f(ratio)
    ratio[0].to_f / ratio[1]
end

def simplify(ratio)
    gcd = gcd(*ratio.sort)
    [ratio[0] / gcd, ratio[1] / gcd]
end

def gcd(a, b)
    a == 0 ? b : gcd(b % a, a) 
end
p backupTimeEstimator((461620201..461620201 + 99).to_a, (5..99).to_a.reverse + [999] * 5, 14)
