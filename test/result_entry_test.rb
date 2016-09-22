require_relative 'test_helper.rb'
require_relative "../../headcount/lib/result_set"
require_relative "../../headcount/lib/result_entry"
require "pry"

class ResultEntryTest < Minitest::Test

  def setup
    @r1 = ResultEntry.new({name: "test1", free_or_reduced_price_lunch: 0.5,
      children_in_poverty: 0.25,
      high_school_graduation: 0.75})
    @r2 = ResultEntry.new({name:"test2",free_or_reduced_price_lunch: 0.3,
      children_in_poverty: 0.2,
      high_school_graduation: 0.6})
    @r3 = ResultEntry.new({name:"test3"})
    end

  def test_name
    assert_equal "test1", @r1.name
  end

  def test_entry
    @r3.add_to_entry({free_or_reduced_price_lunch: 0.3,
      children_in_poverty: 0.2,
      high_school_graduation: 0.6})
    expected = {name: "test3",free_or_reduced_price_lunch: 0.3,
      children_in_poverty: 0.2,
      high_school_graduation: 0.6}
      assert_equal expected, @r3.entry
  end

  def test_can_it_find_free_or_reduced_lunch_rate
    assert_equal 0.5, @r1.free_or_reduced_price_lunch_rate
  end

  def test_can_it_find_children_in_poverty_rate
    assert_equal 0.25, @r1.children_in_poverty_rate
  end

  def test_can_it_find_high_school_graduation_rate
    assert_equal 0.75, @r1.high_school_graduation_rate
  end

end
