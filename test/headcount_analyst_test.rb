require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./test/fixtures/High school graduation rates.csv"
      }
      })
    @h = HeadcountAnalyst.new(dr)

  end

  def test_can_it_create_an_instance_of_HeadcountAnalyst
    assert_instance_of HeadcountAnalyst, @h
  end

  def test_can_it_find_an_average_with_state
    assert_equal 0.766, @h.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end
  def test_can_it_find_an_average_with_district
    assert_equal 0.447, @h.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_trend_state_vs_data_over_all_years
    expected = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
    assert_equal expected, @h.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_vs_high_school_single_district
    assert_equal 0.641, @h.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_does_kindergarten_predict_high_school_graduation_for_district
    skip
    assert true, @h.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_does_kindergarten_predict_high_school_graduation_for_state
    skip
    assert true, @h.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end


end
