class Stack
  attr_accessor :items

  def initialize
    @items = []
  end
  
  def method_missing(method, *arg)
    if items.respond_to?(method)
      items.public_send(method, *arg)
    else
      super
    end
  end

  def dup
    stack = Stack.new
    copy_to(stack, length)
    stack
  end

  private

  def copy_to(stack, count)
    if count > 0
      item = pop
      copy_to(stack, count - 1)
      stack << item
      self << item
    end
  end
end

stack = Stack.new
stack << 1
stack << 2
stack << 3

stack_2 = stack.dup
p stack.items
p stack_2.items
