require_relative 'test_helper'
require_relative '../lib/district_repo'

class TestDistrictRepo < Minitest::Test

  def test_can_it_load_a_file
    repo = DistrictRepo.new

    assert_equal 1992, repo.data.count
  end

end
