class Test
  class << self
    def assert_equals(actual, expected, message = nil)
      if actual == expected
        p "PASSED"
      else
        message ||= 'Expected {expected}, got {actual}'
        message.gsub!('{expected}', expected.to_s)
        message.gsub!('{actual}', actual.to_s)
        p "FAILED. #{message}"
      end
    end
  end
end

include Test

Test.assert_equals(1, 1)
Test.assert_equals(1, 2)
Test.assert_equals(1, 3, '{actual} should be eq {expected}')
