require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class TestDistrict < Minitest::Test

  def setup
    @repo = DistrictRepository.new
    @file = @repo.load_data({:enrollment=>{:kindergarten=>"./test/fixtures/Kindergartners in full-day program.csv"}})
  end

  def test_district_name_has_a_value
    @repo.load_data({
      :enrollment => {
        :kindergarten =>"./test/fixtures/Kindergartners in full-day program.csv"
        }
        })

    assert_equal "COLORADO", @repo.districts.first.name
  end

end
