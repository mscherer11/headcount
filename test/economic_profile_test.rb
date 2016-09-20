require_relative "../../headcount/lib/economic_profile_repository"
require_relative "../../headcount/lib/economic_profile"
require_relative 'test_helper.rb'
require_relative "../../headcount/lib/errors"

class EconomicProfileTest < Minitest::Test
  # include Errors
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
    assert_instance_of EconomicProfile, @epr.economic_profiles.first
  end

  def test_median_household_income_in_year
    testing = @epr.find_by_name("Colorado")
    assert_equal 56222, testing.median_household_income_in_year(2005)
    assert_equal 57408, testing.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
    testing = @epr.find_by_name("Colorado")

    assert_equal 57408, testing.median_household_income_average
  end

  def test_children_in_poverty_in_year
    testing = @epr.find_by_name("Academy 20")

    assert_equal 0.064, testing.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    testing = @epr.find_by_name("Colorado")

    assert_equal 0.41593, testing.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_price_lunch_number_in_year
    testing = @epr.find_by_name("Colorado")

    assert_equal 369760, testing.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_economic_profile_title_i_in_year
    testing = @epr.find_by_name("Colorado")

    assert_equal 0.23556, testing.title_i_in_year(2014)
  end

  def test_errors
    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.median_household_income_in_year(2017)
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.median_household_income_in_year("2005")
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.free_or_reduced_price_lunch_percentage_in_year(2016)
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.free_or_reduced_price_lunch_percentage_in_year(00)
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.free_or_reduced_price_lunch_percentage_in_year("2004")
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("Colorado")
    exception = assert_raises UnknownDataError do
      testing.free_or_reduced_price_lunch_number_in_year("2004")
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("ACADEMY 20")
    exception = assert_raises UnknownDataError do
      testing.children_in_poverty_in_year("2004")
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("ACADEMY 20")
    exception = assert_raises UnknownDataError do
      testing.children_in_poverty_in_year(1994)
    end
    assert_equal("Invalid input.",exception.message)

    testing = @epr.find_by_name("ACADEMY 20")
    exception = assert_raises UnknownDataError do
      testing.title_i_in_year(1)
    end
    assert_equal("Invalid input.",exception.message)
  end

end
