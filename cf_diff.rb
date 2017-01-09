# def displayDiff(oldVersion, newVersion)
#     if oldVersion.empty?
#         return newVersion.empty? ? '' : "[#{newVersion}]"
#     end

#     return "(#{oldVersion})" if newVersion.empty?
    
#     if oldVersion[0] == newVersion[0]
#         i = 1
#         j, k = oldVersion.length, newVersion.length
        
#         min_len = [j, k].min

#         while i < min_len
#             break if oldVersion[i] != newVersion[i]
#             i += 1
#         end
        
#         while j > i && k > i
#             break if oldVersion[j] != newVersion[k]
#             j -= 1
#             k -= 1
#         end
        
#         return oldVersion[0, i] +
#             displayDiff(oldVersion[i..j], newVersion[i..k]) +
#             oldVersion[j + 1..-1].to_s
#     else
#         os = refine("(#{oldVersion[0]})#{displayDiff(oldVersion[1..-1], newVersion)}")
#         ns = refine("[#{newVersion[0]}]#{displayDiff(oldVersion, newVersion[1..-1])}")
#         no_brackets(ns).length < no_brackets(os).length ? ns : os
#     end
# end

# def refine(str)
#     str.gsub(/(\)\(|\]\[)/, '')
# end

def no_brackets(str)
    str.gsub(/[\(\)\[\]]/, '')
end

def lexical_comparable(str)
    str.gsub(/[\(\)]/, '|').gsub(/[\[\]]/, '~')
end

def displayDiff(oldVersion, newVersion)
    if oldVersion.empty?
        return newVersion.empty? ? '' : "[#{newVersion}]"
    end

    return "(#{oldVersion})" if newVersion.empty?
    
    if oldVersion[0] == newVersion[0]
        i = 1
        j, k = oldVersion.length, newVersion.length
        
        min_len = [j, k].min

        while i < min_len
            break if oldVersion[i] != newVersion[i]
            i += 1
        end
        
        while j > i && k > i
            break if oldVersion[j] != newVersion[k]
            j -= 1
            k -= 1
        end
        
        return oldVersion[0, i] +
            displayDiff(oldVersion[i..j], newVersion[i..k]) +
            oldVersion[j + 1..-1].to_s
    else
        i = 0

        newVersion_hash = Hash[newVersion.split('').each_with_index.to_a.map(&:reverse)]

        candidates = []

        while i < oldVersion.length
            if (j = newVersion_hash.key(oldVersion[i]))
                candidates << [i, j]
            end
            i += 1
        end

        candidates << [oldVersion.length, newVersion.length] if candidates.empty?
        
        candidates.map do |i, j|
            removals = i == 0 ? '' : "(#{oldVersion[0..i - 1]})"
            additions = j == 0 ? '' : "[#{newVersion[0..j - 1]}]"
            result_str = "#{removals}#{additions}#{displayDiff(oldVersion[i..-1], newVersion[j..-1])}"
            [
                result_str,
                no_brackets(result_str).length,
                result_str.split('').map do |char|
                    if char == '(' || char == ')'
                        '9998'
                    elsif char == '[' || char == ']'
                        '9999'
                    else
                        char.ord.to_s.rjust(4, '0')
                    end
                end.join('')
            ]
        end.sort do |a, b|
            a[1] == b[1] ? a[2] <=> b[2] : a[1] <=> b[1]
        end.first.first
    end
end

p displayDiff('same_prefix_1233_same_suffix', 'same_prefix23123_same_suffix')
