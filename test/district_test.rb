require_relative 'test_helper'
require_relative '../lib/district'

class TestDistrict < Minitest::Test

  def test_it_has_a_name
    district = District.new
    assert_equal "TEST", district.name("test")
  end

end
