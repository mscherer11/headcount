require_relative "../../headcount/lib/headcount_analyst"
require_relative "../../headcount/lib/economic_profile_repository"
require_relative "../../headcount/lib/economic_profile"
require_relative 'test_helper.rb'

class EconomicProfileTest < Minitest::Test
  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
      }
    })
  end

  def test_create_instance_of_economic_profile
    assert_instance_of EconomicProfile, @ep
  end

  def test_median_household_income_in_year
    testing = @epr.find_by_name("Colorado")
    # assert_equal 50000, @ep.median_household_income_in_year(2005)
    assert_equal 57408, testing.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
    skip
    assert_equal 55000, @ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    skip
    assert_equal 0.184, @ep.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    skip
    assert_equal 0.023, @ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_price_lunch_number_in_year
    skip
    assert_equal 100, @ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_economic_profile_title_i_in_year
    skip
    assert_equal 0.543, @ep.title_i_in_year(2015)
  end
end
