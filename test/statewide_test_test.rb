require_relative "../../headcount/lib/headcount_analyst"
require_relative "../../headcount/lib/statewide_test_repository"
require_relative "../../headcount/lib/statewide_test"
require_relative 'test_helper.rb'

class StatewideTestTest < Minitest::Test
  def setup
    @statewide_test = StatewideTestRepository.new
    @statewide_test.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_proficiency_by_grade_returns_values
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }
   testing = @statewide_test.find_by_name("ACADEMY 20")
   assert_equal expected, testing.proficient_by_grade(3)
  end

  def test_errors
    testing = @statewide_test.find_by_name("ACADEMY 20")
    exception = assert_raises UnknownDataError do
      testing.proficient_by_grade(1)
    end
    assert_equal("Invalid input.",exception.message)

    exception = assert_raises UnknownDataError do
      testing.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end
    assert_equal("Invalid input.",exception.message)

    exception = assert_raises UnknownDataError do
      testing.proficient_for_subject_by_race_in_year(:reading, :pizza, 2013)
    end
    assert_equal("Invalid input.",exception.message)

    exception = assert_raises UnknownDataError do
      testing.proficient_for_subject_by_race_in_year(:pizza, :white, 2013)
    end
    assert_equal("Invalid input.",exception.message)
  end

  def test_proficient_by_race_or_ethnicity_returns_values
    testing = @statewide_test.find_by_name("ACADEMY 20")
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
               }
    assert_equal expected, testing.proficient_by_race_or_ethnicity(:asian)
  end

  def test_can_it_get_the_proficiency_by_grade_subject_and_year
    testing = @statewide_test.find_by_name("ACADEMY 20")
    assert_equal 0.857, testing.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_can_it_get_the_proficiency_by_race_subject_and_year
    testing = @statewide_test.find_by_name("ACADEMY 20")
    assert_equal 0.818, testing.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

end
