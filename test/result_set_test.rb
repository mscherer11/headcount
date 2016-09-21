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
    assert_equal expected, @result.raw[:high_school_graduation]["COLORADO"]
  end

  def test_can_it_create_average_for_a_district
    assert_equal 0.751708, @result.district_average(:high_school_graduation, "COLORADO")
  end

  def test_can_it_search_a_name
    assert_instance_of ResultEntry, @result.find_by_name("ACADEMY 20")
  end

  def test_can_it_find_matching_districts
    assert_equal "TEST1", @result.matching_districts(:median_household_income, 1).first.name
    assert_equal "TEST2", @result.matching_districts(:median_household_income, 1).last.name
  end

  def test_can_it_calculate_statewide_average
    assert_equal 60434.916666666664, @result.statewide_average(:median_household_income)
    assert_equal 0.13543411764705884, @result.statewide_average(:children_in_poverty)
  end

  def test_can_it_find_districts_with_high_poverty_and_graduation_rates
    assert_equal 1, @result.high_poverty_and_high_school_graduation.count
  end

end
