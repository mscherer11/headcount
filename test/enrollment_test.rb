require_relative 'test_helper'
require_relative '../lib/enrollment'

class TestEnrollment < Minitest::Test
  def setup
    @e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_enrollment_can_be_insantiated_with_name_and_enrollment
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    assert_equal "ACADEMY 20", @e.name
    assert_equal expected, @e.data[:kindergarten_participation]
  end

  def test_participate_by_year
    data = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal data, @e.kindergarten_participation_by_year
  end

  def test_participate_in_year
    assert_equal 0.3915, @e.kindergarten_participation_in_year(2010)
  end

  def test_it_can_update_kindergarten_participation
    enrollment = @e

    assert_equal 3, enrollment.data[:kindergarten_participation].size
    enrollment.add_participation({2013 => 0.48774}, :kindergarten_participation)
    assert_equal 4, enrollment.data[:kindergarten_participation].size
    assert_equal 0.48774, enrollment.kindergarten_participation_in_year(2013)
  end

end
