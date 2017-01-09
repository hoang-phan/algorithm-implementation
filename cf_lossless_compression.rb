def losslessDataCompression(inputString, width)
    result = ''
    i = 0
    length = inputString.length

    while i < length
        start_window = [i - width, 0].max
        window = i < 1 ? '' : inputString[start_window..i - 1]
        
        if window.index(inputString[i])
            w_length = window.length
            j = 0
            last_offset = 0
            
            while j < w_length && j < length - i
                reach = inputString[i..i + j]
                p "reach: #{reach}"
                offset = window.index(reach)
                p "offset: #{offset}"
                break unless offset
                last_offset = offset
                j += 1
            end

            result += "(#{start_window + last_offset},#{j})"
            i += j
        else
            result << inputString[i]
            i += 1
        end
    end
    
    result
end

def extract(inputString)
    i = 0
    result = ''

    while i < inputString.length
        b_start_i = inputString.index('(', i)
        if b_start_i
            result += inputString[i..b_start_i - 1]
            b_end_i = inputString.index(')', b_start_i)
            block = inputString[b_start_i..b_end_i]
            start, len = block[1..-2].split(',').map(&:to_i)
            result += result[start..start + len - 1]
            i = b_end_i + 1
        else
            result += inputString[i..-1]
            i = inputString.length
        end
    end

    result
end

p losslessDataCompression('a' * 30 + 'z' * 10, 6)
