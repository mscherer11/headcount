require_relative 'test_helper'
require_relative '../lib/load'

class LoadModuleTest < Minitest::Test


  def test_if_file_name_is_passed_through_the_method

    assert_equal "test.csv", Load.file_load("test.csv")
  end

end
