def packageBoxing(pkg, boxes)
  pk = pk.sort
  fits = boxes.each_with_index.map do |raw_box, index|
    box = raw_box.sort
    [index, box, box[0] * box[1] * box[2]]
  end.select do |(index, box, vol)|
    pk[0] <= box[0] && pk[1] <= box[1] && pk[2] <= box[2]
  end

  min = fits.map(&:last).min

  fits.index { |(index, box, vol)| vol == min } || -1
end
