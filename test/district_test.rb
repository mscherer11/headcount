require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class TestDistrict < Minitest::Test

  def setup
    @repo = DistrictRepository.new
    @file = @repo.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv",
      :high_school_graduation => "./test/fixtures/High school graduation rates.csv"
    },
        :statewide_testing => {
          :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
          :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
          :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
          :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
          :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
  end

  def test_district_name_has_a_value
    assert_equal "COLORADO", @repo.districts.first.name
  end

end
