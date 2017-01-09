class Josephus
  attr_accessor :m, :people, :position
  
  def initialize(m, n)
    @m = m
    @position = 0
    @people = n.times.to_a
  end

  def start
    while people.length > 0
      eliminate
    end
  end

  private

  def eliminate
    length = people.length
    @position = (position + m - 1) % length
    p people.delete_at(position)
  end
end

class JosephusQueue
  attr_accessor :m, :people
  
  def initialize(m, n)
    @m = m
    @people = Queue.new
    people = n.times { |i| people << i }
  end

  def start
    while people.length > 0
      eliminate
    end
  end

  private

  def eliminate
    m.times { people << people.pop }
    p people.pop
  end
end

Josephus.new(2, 7).start
