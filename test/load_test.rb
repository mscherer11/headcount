require_relative 'test_helper'
require_relative '../lib/load'

class LoadModuleTest < Minitest::Test


  def test_if_it_can_load_a_file
    refute nil, Load.file_load("./test/fixtures/Kindergartners in full-day program.csv")
  end

end
