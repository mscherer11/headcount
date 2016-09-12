require_relative 'test_helper'
require './lib/data_scrub'

class TestDataScrub < Minitest::Test
  def test_if_name_is_clean
    name_1 = "Colorado"
    assert_equal "COLORADO", DataScrub.clean_name(name_1)
    name_2 = "colorado"
    assert_equal "COLORADO", DataScrub.clean_name(name_2)
    name_3 = "ColORado"
    assert_equal "COLORADO", DataScrub.clean_name(name_3)
    name_4 = "cOloRAdo"
    assert_equal "COLORADO", DataScrub.clean_name(name_4)
  end

  def test_data_is_float
    data_1 = 1
    assert_equal 1.0, DataScrub.clean_data(data_1)
    data_2 = 1.23746
    refute_equal 1, DataScrub.clean_data(data_2)
  end
end
