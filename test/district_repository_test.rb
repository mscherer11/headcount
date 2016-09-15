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

end
