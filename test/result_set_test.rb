require_relative 'test_helper.rb'
require_relative "../../headcount/lib/result_set"

class ResultSetTest < Minitest::Test

  def setup
    @result = ResultSet.new
    @result.load_data({
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
        :median_household_income => "./test/fixtures/Median household income.csv",
        :children_in_poverty => "./test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/Students qualifying for free or reduced price lunch.csv",
      })
  end

  def test_can_it_create_an_instance_of_ResultSet
    assert_instance_of ResultSet, @result
  end

  def test_can_it_populate_ResultSet_with_data
    refute_equal [], @result.raw
  end

  def test_can_it_create_raw_data
    refute @result.raw.empty?
  end

  def test_are_all_the_files_loaded
    assert_equal [:high_school_graduation, :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch], @result.raw.keys
  end

  def test_can_it_find_raw_data
    expected = {"2010"=>0.724, "2011"=>0.739, "2012"=>0.75354, "2013"=>0.769, "2014"=>0.773}
    assert_equal expected, @result.raw[:high_school_graduation]["Colorado"]
  end


end
