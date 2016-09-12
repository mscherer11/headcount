require_relative 'test_helper'
require_relative '../lib/enrollment'

class TestEnrollment < Minitest::Test
  def test_participate_by_year
    enrollment = Enrollment.new
    data = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal data, enrollment.kindergarten_participation_by_year({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
  end

  def test_participate_in_year
    enrollment = Enrollment.new
    assert_equal 0.3915, enrollment.kindergarten_participation_in_year(2010)
  end

end
