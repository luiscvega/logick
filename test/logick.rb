require "cutest"
require_relative "../lib/logick"

class AddTwoNumbers < Logick
  attr_accessor :number_1, :number_2

  def validate
    assert number_1.is_a?(Integer), [:number_1, :not_integer]
    assert number_2.is_a?(Integer), [:number_2, :not_integer]
  end

  def run
    number_1 + number_2
  end
end

class AddThenSquareTwoNumbers < Logick
  attr_accessor :number_1, :number_2

  def validate
    assert number_1.is_a?(Integer), [:number_1, :not_integer]
    assert number_2.is_a?(Integer), [:number_2, :not_integer]
  end

  def run
    AddTwoNumbers.run(number_1: number_1, number_2: number_2)**2
  end
end

test "successfully add two numbers" do
  result = Logick.perform { AddTwoNumbers.run(number_1: 1, number_2: 2) }

  assert result.success?
  assert_equal result.output, 3
end

test "unsuccessfully add two numbers" do
  result = Logick.perform { AddTwoNumbers.run(number_1: "1", number_2: "2") }

  assert result.fail?
  assert_equal result.errors, {
    :number_1 => [:not_integer],
    :number_2 => [:not_integer]
  }
end

test "successfully add then square two numbers" do
  result = Logick.perform { AddThenSquareTwoNumbers.run(number_1: 1, number_2: 2) }

  assert result.success?
  assert_equal result.output, 9
end
