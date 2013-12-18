require "cutest"
require_relative "../lib/logic"

class AddTwoNumbers < Logic::Scrivener
  attr_accessor :number_1, :number_2

  def validate
    assert number_1.is_a?(Integer), [:number_1, :not_integer]
    assert number_2.is_a?(Integer), [:number_2, :not_integer]
  end

  def run
    if number_1 == 3
      throw(:fail, AddTwoNumbersResult.new(type: :fail, output: self, errors: { number_1: [:cannot_be_3] }))
    end

    number_1 + number_2
  end

  class AddTwoNumbersResult < Logic::Result
    def number_1_is_3?
      errors[:number_1].include?(:cannot_be_3)
    end
  end
end

class AddThenSquareTwoNumbers < Logic::Scrivener
  attr_accessor :number_1, :number_2

  def validate
    assert number_1.is_a?(Integer), [:number_1, :not_integer]
    assert number_2.is_a?(Integer), [:number_2, :not_integer]
  end

  def run
    AddTwoNumbers.run(number_1: number_1, number_2: number_2) * AddTwoNumbers.run(number_1: number_1, number_2: number_2)
  end
end

test "successfully add two numbers" do
  result = Logic.perform { AddTwoNumbers.run(number_1: 1, number_2: 2) }

  assert result.success?
  assert_equal result.output, 3
end

test "unsuccessfully add two numbers" do
  result = Logic.perform { AddTwoNumbers.run(number_1: "1", number_2: "2") }

  assert result.fail?
  assert_equal result.errors, {
    :number_1 => [:not_integer],
    :number_2 => [:not_integer]
  }
end

test "successfully add two multiplied numbers" do
  result = Logic.perform { AddThenSquareTwoNumbers.run(number_1: 1, number_2: 2) }

  assert result.success?
  assert_equal result.output, 9
end

test "unsuccessfully add two multiplied numbers" do
  result = Logic.perform { AddThenSquareTwoNumbers.run(number_1: 3, number_2: 2) }

  assert result.fail?
  assert result.number_1_is_3?
  assert_equal result.errors, {
    :number_1 => [:cannot_be_3]
  }
end
