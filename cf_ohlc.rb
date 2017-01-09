def dailyOHLC(timestamp, instrument, side, price, size)
    ohlc = {}

    timestamp.each_with_index do |time, index|
        date = Time.at(time).utc.strftime('%Y-%m-%d')
        ins = instrument[index]
        pr = price[index]
        ohlc[date] ||= {}
        ohlc[date][ins] ||= {}
        
        if ohlc[date][ins].empty?
            ohlc[date][ins] = [pr, pr, pr, pr]
        else
            ohlc[date][ins][1] = pr if pr > ohlc[date][ins][1]
            ohlc[date][ins][2] = pr if pr < ohlc[date][ins][2]
            ohlc[date][ins][3] = pr
        end
    end
    
    ohlc.flat_map do |date, records|
        records.map do |instrument, prices|
            [date, instrument] + prices.map { |pr| '%.02f' % pr }
        end
    end.sort do |o1, o2|
        o1[0] == o2[0] ? o1[1] <=> o2[1] : o1[0] <=> o2[0]
    end
end

p dailyOHLC(
    [1450625399, 1450625400, 1450625500, 1450625550, 1451644200, 1451690100, 1451691000],
    ["HPQ", "HPQ", "HPQ", "HPQ", "AAPL", "HPQ", "GOOG"],
    ["sell", "buy", "buy", "sell", "buy", "buy", "buy"],
    [10, 20.3, 35.5, 8.65, 20, 10, 100.35],
    [10, 1, 2, 3, 5, 1, 10]
)
