require_relative 'test_helper'
require_relative '../lib/district_repository'

class TestDistrictRepository < Minitest::Test

  def setup
    @repo = DistrictRepository.new
    @file = @repo.load_data({:enrollment=>{:kindergarten=>"./test/fixtures/Kindergartners in full-day program.csv"}})
  end

  def test_can_repo_collect_data
    assert_equal 2, @repo.districts.length
  end

  def test_can_it_search_a_name
    district = @repo.find_by_name("COLORADO")

    assert_instance_of District, district
    assert_equal "COLORADO", district.name
  end

  # def test_can_it_find_all_matches
  #   assert_equal 2, find_all_matching("C")
  # end

  # def test_does_it_return_nil_when_matches_not_found
  #
  # end

end
