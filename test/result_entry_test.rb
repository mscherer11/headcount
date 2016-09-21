require_relative 'test_helper.rb'
require_relative "../../headcount/lib/result_set"
require_relative "../../headcount/lib/result_entry"
require "pry"

class ResultEntryTest < Minitest::Test

  def setup
    @result = ResultSet.new
    @result.load_data({
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
        :median_household_income => "./test/fixtures/Median household income.csv",
        :children_in_poverty => "./test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/Students qualifying for free or reduced price lunch.csv",
      })
  end

  def test_can_it_create_a_Result_entry
    assert_instance_of ResultEntry, @result.result_entries.first
  end

  def test_can_it_add_data
    name = @result.find_by_name("COLORADO")
    assert_equal [:high_school_graduation, :median_household_income, :free_or_reduced_price_lunch], name.data.keys
  end

  def test_does_it_have_free_and_reduced_price_lunch_rate
    name = @result.find_by_name("ACADEMY 20")


    assert_equal 0.3501060000000001, name.free_or_reduced_price_lunch_rate
  end

  def test_does_it_have_children_in_poverty_rate
    name = @result.find_by_name("ACADEMY 20")
    assert_equal 0.04115176470588236, name.children_in_poverty_rate
  end

  def test_does_it_have_high_school_graduation_rate
    name = @result.find_by_name("ACADEMY 20")
    assert_equal 0.751708, name.high_school_graduation_rate
  end

  def test_does_it_median_household_income
    name = @result.find_by_name("ACADEMY 20")
    assert_equal 57408.0, name.median_household_income
  end


end
