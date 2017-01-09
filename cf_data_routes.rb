# Ford-Fukersion
def dataRoute(resource, server, network)
    result = 0
    nodes = network.count.times.to_a

    while true
        old_time = Time.now.to_f
        paths = next_route(resource, server, network, nodes)[0]
        p "Recursive time: #{Time.now.to_f - old_time}"

        return result unless paths

        time1 = Time.now.to_f
        min_capacity = paths.map do |(from, to)|
            network[from][to]
        end.min
        
        paths.each do |(from, to)|
            network[from][to] -= min_capacity
            network[to][from] += min_capacity
        end
        
        result += min_capacity
        p "Time 1 : #{Time.now.to_f - time1}"
    end
end

def next_route(from, to, network, nodes, paths)
    return paths if from == to
    
    available_nodes = nodes - [from]
    available_nodes.each do |intermediate|
        next if network[from][intermediate] == 0
        if route = next_route(intermediate, to, network, available_nodes, paths + [[from, intermediate]])
            return route
        end
    end
    
    nil
end

# Push-Relabel
def dataRoute(resource, server, network)
    # init
    count = network.count
    all_nodes = count.times.to_a

    heights = Array.new(count) { 0 }
    excesses = Array.new(count) { 0 }
    heights[resource] = count
    ends = (all_nodes - [resource])

    # preflow
    ends.each do |node|
        excesses[node] = network[resource][node]
        network[node][resource] = excesses[node]
        network[resource][node] = 0
    end

    intermediates = ends - [server]

    while true
        from = intermediates.detect { |node| excesses[node] > 0 }
        break unless from

        dsts = [resource] + ends - [from]

        # push
        push = false
        dsts.each do |to|
            if heights[from] > heights[to] && network[from][to] > 0
                d_flow = [excesses[from], network[from][to]].min
                excesses[from] -= d_flow
                excesses[to] += d_flow
                network[from][to] -= d_flow
                network[to][from] += d_flow
                push = true
            end
        end

        # relabel
        if !push
            min_height = 999
            dsts.each do |to|
                if network[from][to] > 0 && heights[to] < min_height
                    min_height = heights[to]
                end 
            end
            heights[from] = min_height + 1
        end
    end

    excesses[server]
end

resource = 0
server = 14
network = Array.new(15) { Array.new(15) { 0 } }

network = [[0, 0, 0, 0, 3250, 8453, 7110, 1243, 3195, 2030, 4895, 7192, 9859, 1083, 0], [0, 0, 1540, 0, 1502, 0, 0, 1494, 0, 864, 6228, 5532, 0, 0, 6320], [0, 5519, 0, 0, 0, 8213, 3747, 0, 0, 4811, 0, 6192, 0, 0, 5138], [0, 0, 0, 0, 1336, 2692, 0, 0, 6588, 6072, 1482, 0, 0, 0, 7289], [0, 469, 187, 2652, 0, 0, 4673, 2055, 590, 0, 686, 0, 7933, 0, 0], [0, 977, 0, 7407, 0, 0, 9207, 2488, 7057, 0, 0, 8541, 9827, 6129, 0], [0, 3098, 8390, 0, 0, 2618, 0, 6078, 0, 0, 6938, 0, 3833, 8781, 2457], [0, 7813, 0, 380, 1395, 7012, 0, 0, 2040, 0, 0, 7892, 8773, 2782, 0], [0, 9997, 0, 1416, 0, 0, 7049, 0, 0, 0, 0, 1129, 5173, 6664, 488], [0, 0, 7667, 0, 0, 0, 4299, 6543, 8712, 0, 9646, 0, 0, 0, 1928], [0, 3126, 0, 4001, 5598, 2866, 0, 0, 4600, 4052, 0, 0, 5212, 0, 0], [0, 4868, 30, 5813, 0, 6533, 4789, 8646, 0, 0, 0, 0, 0, 3637, 1642], [0, 6453, 0, 9286, 0, 8990, 0, 2028, 0, 6111, 6293, 9626, 0, 9061, 1867], [0, 4629, 0, 7131, 1890, 1917, 3883, 0, 0, 3013, 5552, 0, 0, 0, 7506], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

p dataRoute(resource, server, network)
