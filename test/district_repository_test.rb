require_relative 'test_helper'
require_relative '../lib/district_repository'
require 'pry'

class TestDistrictRepository < Minitest::Test

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
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
        }
      })
  end

  def test_can_repo_collect_data
    assert_equal 2, @repo.districts.length
  end

  def test_can_it_search_a_name
    district = @repo.find_by_name("COLORADO")

    assert_instance_of District, district
    assert_equal "COLORADO", district.name
  end

  def test_can_it_find_all_matches
    assert_equal 2, @repo.find_all_matching("C").count
    assert_equal 1, @repo.find_all_matching("Co").count
  end

  def test_can_it_create_an_instance_of_EnrollmentRepository
    assert_instance_of EnrollmentRepository, @repo.enrollment_repo
  end

  def test_can_it_populate_EnrollmentRepository_with_data
    refute_equal [], @repo.enrollment_repo.enrollments
  end

  def test_can_it_return_a_data_value
    district = @repo.find_by_name("ACADEMY 20")
    assert_equal 0.30201, district.enrollment.kindergarten_participation_in_year(2004)
  end

  def test_can_it_create_an_instance_of_StatewideRepository
    assert_instance_of StatewideTestRepository, @repo.statewide_test_repository
  end

  def test_can_it_populate_StatewideRepository_with_data
    refute_equal [], @repo.statewide_test_repository.statewide
  end

  def test_can_it_create_an_instance_of_StatewideRepository
    assert_instance_of EconomicProfileRepository, @repo.economic_profile_repository
  end

  def test_can_it_populate_StatewideRepository_with_data
    refute_equal [], @repo.economic_profile_repository.economic_profiles
  end

end
