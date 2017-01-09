def packageBoxing(pkg, boxes)
  pk = pk.sort
  fits = boxes.each_with_index.map do |raw_box, index|
    box = raw_box.sort
    [index, box, box[0] * box[1] * box[2]]
  end.select

  fits.index(fits.min) || -1
end
