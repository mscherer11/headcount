require_relative "../../headcount/lib/district_repository"
require_relative "../../headcount/lib/district"
require_relative "../../headcount/lib/enrollment"
require_relative "../../headcount/lib/headcount_analyst"
require_relative "../../headcount/lib/statewide_test_repository"
require_relative 'test_helper.rb'

class StatewideTestRepositoryTest < Minitest::Test
  def setup
    @str = StatewideTestRepository.new
    @str.load_data({
      :statewide_testing => {
        # :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        # :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_create_instance_of_statewide_repo
    assert_instance_of StatewideTestRepository, @str
  end

  def test_find_by_name

    assert @str.find_by_name("ACADEMY 20")
    assert @str.find_by_name("GUNNISON WATERSHED RE1J")
  end


end
