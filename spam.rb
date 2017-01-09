def kikCode(userId)
    bits = to_reverse_bits(userId.to_i)

    sectors_counts.each_with_index.inject([]) do |result, (bit_count, c_index)|
        sub_bits = bits[0..bit_count - 1] 
        bits = bits[bit_count..-1]

        ref_sectors = []
        one_indices = sub_bits.length.times.select { |i| sub_bits[i] == '1' }
        
        sec_start = sec_end = one_indices.shift
        
        one_indices.each do |index|
            if index == sec_end + 1
                sec_end = index
            else
                ref_sectors << [sec_start, sec_end]
                sec_start = sec_end = index
            end
        end

        ref_sectors << [sec_start, sec_end] if sec_start
        
        if ref_sectors.count > 1 && ref_sectors.first[0] == 0 && ref_sectors.last[1] == bit_count - 1
            ref_sectors.last[1] = ref_sectors.first[1] + bit_count
            ref_sectors.shift
        end

        result + ref_sectors.map do |(sec_start, sec_end)|
            [
                [c_index + 1, sectors_widths[c_index] * sec_start],
                [c_index + 1, sectors_widths[c_index] * (sec_end + 1)]
            ]
        end
    end
end

def to_reverse_bits(decimal)
    bits = ''
    while decimal >= 2
        bits += (decimal % 2).to_s
        decimal /= 2
    end
    bits += decimal.to_s
    bits.ljust(52, '0')
end

def sectors_counts
    [3, 4, 8, 10, 12, 15]
end

def sectors_widths
    @sectors_widths ||= sectors_counts.map { |cnt| 360 / cnt }
end

p kikCode("0")
