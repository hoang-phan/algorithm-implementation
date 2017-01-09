require 'date'
class Transaction
  attr_accessor :date, :customer, :amount

  def initialize(str)
    @customer, date_str, amount_str = str.split(' ')
    @date = Date.strptime(date_str, '%m/%d/%Y')
    @amount = amount_str.to_f
  end
end

transaction = Transaction.new('Turing 5/22/1939 11.99')
p transaction.customer
p transaction.date.to_s
p transaction.amount
