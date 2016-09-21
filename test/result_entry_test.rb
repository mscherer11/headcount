require_relative 'test_helper.rb'
require_relative "../../headcount/lib/result_set"
require_relative "../../headcount/lib/result_entry"
require "pry"

class ResultEntryTest < Minitest::Test

  def setup
    @result = ResultSet.new
    @result.load_data({
      :enrollment => {
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        }
      })
  end

  def test_can_it_create_a_Result_entry
    assert_instance_of ResultEntry, @result.result_entries.first
  end

  def test_case_name

  end

end
