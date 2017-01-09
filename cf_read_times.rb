require 'json'
# def relatedQuestions(n, t, edges)
#     connected = edges.each_with_object({}) do |(v1, v2), result|
#         result[v1] ||= []
#         result[v1] << v2
#         result[v2] ||= []
#         result[v2] << v1
#     end

#     min_read_time = t.reduce(&:+)
#     min_index = -1

#     read_times = t.count.times.map do |index|
#         r = read_time(t, connected, index, min_read_time)
#         if r < min_read_time
#             min_read_time = r
#             min_index = index
#         end
#     end
    
#     min_index
# end

# def read_time(t, connected, start, min_read_time)
#     queue = [[start, 1]]
#     processed = [start]
    
#     result = 0
    
#     while !queue.empty?
#         i, divisor = queue.shift
#         next_is = connected[i] - processed
#         result += t[i] / divisor.to_f
#         next_divisor = divisor.to_f * next_is.count
#         processed += next_is
#         queue += next_is.map { |ni| [ni, next_divisor] }
#     end
    
#     result
# end

# a = ARGV[0].to_i
# p relatedQuestions(a, [2] * (a - 10) + [1] + [2] * 9, (a - 1).times.map {|t| [t, t + 1]})

def relatedQuestions(n, t, edges)
    # calculate map of connection: O(E)

    connected = edges.each_with_object({}) do |(v1, v2), result|
        result[v1] ||= []
        result[v1] << v2
        result[v2] ||= []
        result[v2] << v1
    end

    # build tree and tree level map at root 0: O(V)

    processed = [0]
    queue = [[0, 0]]
    tree = {}
    tree_levels = {}

    while !queue.empty?
        i, level = queue.shift

        children = connected[i].to_a - processed
        tree[i] = children
        
        tree_levels[level] ||= []
        tree_levels[level] << i

        # for reverse sort
        new_level = level - 1
        processed += children
        queue += children.map { |ni| [ni, new_level] }
    end

    # calculate total read time at each node with its lower children: O(V)

    tree_vals = {}

    tree_levels.sort_by(&:first).each do |(level, nodes)|
        nodes.each do |node|
            children_count = tree[node].count.to_f

            tree_vals[node] = tree[node].inject(t[node]) do |result, child|
                result + tree_vals[child] / children_count
            end 
        end
    end

    parent = 0

    # calculate read times totally: O(V)

    @read_times = { }
    calculate_read_times(0, tree_vals, tree, t, tree[parent].count.to_f)

    @read_times.key(@read_times.values.min)
end

def calculate_read_times(parent, tree_vals, tree, t, c_count)
    @read_times[parent] = tree_vals[parent]

    (tree[parent] - @read_times.keys).each do |child|
        old = [tree_vals[parent], tree_vals[child], tree[parent].dup, tree[child].dup]

        grandc_count = tree[child].count.to_f

        extra_parent = c_count == 1 ? 0 : ((tree_vals[parent] - t[parent]) * c_count - tree_vals[child]) / (c_count - 1)
        tree_vals[parent] = t[parent] + extra_parent

        tree_vals[child] = t[child] +
                                ((tree_vals[child] - t[child]) * grandc_count + tree_vals[parent]) / (grandc_count + 1)

        tree[parent] -= [child]
        tree[child] << parent

        calculate_read_times(child, tree_vals, tree, t, grandc_count + 1)

        tree_vals[parent], tree_vals[child], tree[parent], tree[child] = old
    end
end

a = ARGV[0].to_i
p relatedQuestions(a, [2] * (a - 10) + [1] + [2] * 9, (a - 1).times.map {|t| [t, t + 1]})
