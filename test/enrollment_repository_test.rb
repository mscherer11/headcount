require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class TestEnrollmentReposiotry < Minitest::Test

  def setup
    @repo = EnrollmentRepository.new
    @file = @repo.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
  end

  def test_can_repo_collect_data
    binding.pry
    assert_equal 2, @repo.enrollments.length
  end

  def test_can_it_search_a_name
    enrollment = @repo.find_by_name("COLORADO")
    assert_instance_of Enrollment, enrollment
    assert_equal "COLORADO", enrollment.data[:name]
  end

  def test_it_loads_kindergarten_participation
    enrollment = @repo.find_by_name("COLORADO")
    kindergarten_participation = enrollment.data[:kindergarten_participation]

    assert_equal 11, kindergarten_participation.length
    #test quality of the hash/use expected hash
  end

end
