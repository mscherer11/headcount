require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class TestEnrollmentReposiotry < Minitest::Test

  def setup
    @repo = EnrollmentRepository.new
    @file = @repo.load_data({:enrollment=>{:kindergarten=>"./test/fixtures/Kindergartners in full-day program.csv"}})
  end

  def test_can_repo_collect_data
    assert_equal 2, @repo.enrollments.length
  end

  def test_can_it_search_a_name
    enrollment = @repo.find_by_name("COLORADO")

    assert_instance_of Enrollment, enrollment
    assert_equal "COLORADO", enrollment.name
  end

  def test_it_loads_kindergarten_participation
    enrollment = @repo.find_by_name("COLORADO")
    kindergarten_participation = enrollment.kindergarten_participation

    assert_equal 11, kindergarten_participation.length
    #test quality of the hash/use expected hash
  end

end
