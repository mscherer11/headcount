require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class TestDistrict < Minitest::Test

  def test_district_name_has_a_value
    repo = DistrictRepository.new
    repo.load_data("./test/fixtures/Kindergartners in full-day program.csv")

    assert_equal "COLORADO", repo.districts.first.name
  end

end
