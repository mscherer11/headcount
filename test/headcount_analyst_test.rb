require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/result_set'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
    },
        :statewide_testing => {
          :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
          :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
          :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
          :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
          :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
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
    assert_equal true, @h.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_does_kindergarten_predict_high_school_graduation_for_state
    assert_equal false, @h.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_does_kindergarten_predict_high_school_graduation_across_districts
  districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
  assert @h.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_can_it_create_a_Result_entry
    @h.calculate_statewide_average(:high_school_graduation)
    assert_instance_of ResultEntry, @h.result_set.matching_districts.first
  end

  def test_can_it_create_an_average
    assert_equal 49705, @h.calculate_statewide_average(:median_household_income)
    assert_equal 0.4091990313075509, @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    assert_equal 0.16400180695482608, @h.calculate_statewide_average(:children_in_poverty)
    assert_equal 0.8103222651933705, @h.calculate_statewide_average(:high_school_graduation)
  end

  def test_can_it_find_an_entry_name
    @h.calculate_statewide_average(:high_school_graduation)
    refute nil, @h.find_entry("statewide_average")
  end

  def test_can_it_add_entries
    @h.calculate_statewide_average(:median_household_income)
    @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    @h.calculate_statewide_average(:children_in_poverty)
    @h.calculate_statewide_average(:high_school_graduation)

    assert_equal 1, @h.result_set.matching_districts.count
  end

  def test_can_it_find_median_household_incomes
    refute_equal 0, @h.generic_search(@h.district_repo.districts, :median_household_income, 49705)
  end

  def test_can_it_find_high_poverty_and_high_school_grads
    @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    @h.calculate_statewide_average(:children_in_poverty)
    @h.calculate_statewide_average(:high_school_graduation)
    @h.high_poverty_and_high_school_graduation
  end

  def test_can_it_create_a_statewide_average
    @h.calculate_statewide_average(:median_household_income)
    @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    @h.calculate_statewide_average(:children_in_poverty)
    @h.calculate_statewide_average(:high_school_graduation)

    assert_equal "statewide_average", @h.result_set.matching_districts.first.entry[:name]
    assert_equal 49705, @h.result_set.matching_districts.first.entry[:median_household_income]
    assert_equal 0.4091990313075509, @h.result_set.matching_districts.first.entry[:free_or_reduced_price_lunch]
    assert_equal 0.16400180695482608, @h.result_set.matching_districts.first.entry[:children_in_poverty]
    assert_equal 0.8103222651933705, @h.result_set.matching_districts.first.entry[:high_school_graduation]
  end

  def test_can_it_create_a_district_average
    @h.calculate_statewide_average(:median_household_income)
    @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    @h.calculate_statewide_average(:children_in_poverty)
    @h.calculate_statewide_average(:high_school_graduation)

    @h.high_poverty_and_high_school_graduation

    assert_equal 39, @h.result_set.matching_districts.count
    assert_equal "WILEY RE-13 JT", @h.result_set.matching_districts.last.entry[:name]
    assert_equal 50934, @h.result_set.matching_districts.last.entry[:median_household_income]
    assert_equal 0.47784466666666664, @h.result_set.matching_districts.last.entry[:free_or_reduced_price_lunch]
    assert_equal 0.21190117647058826, @h.result_set.matching_districts.last.entry[:children_in_poverty]
    assert_equal 0.8240000000000001, @h.result_set.matching_districts.last.entry[:high_school_graduation]
  end

  def test_can_averages_be_compared
    @h.calculate_statewide_average(:median_household_income)
    @h.calculate_statewide_average(:free_or_reduced_price_lunch)
    @h.calculate_statewide_average(:children_in_poverty)
    @h.calculate_statewide_average(:high_school_graduation)
    @h.income_disparity

    assert_equal 15, @h.result_set.matching_districts.count
    assert_equal "WILEY RE-13 JT", @h.result_set.matching_districts.last.entry[:name]
    assert_equal 50934, @h.result_set.matching_districts.last.entry[:median_household_income]
    assert_equal 0.47784466666666664, @h.result_set.matching_districts.last.entry[:free_or_reduced_price_lunch]
    assert_equal 0.21190117647058826, @h.result_set.matching_districts.last.entry[:children_in_poverty]
    assert_equal 0.8240000000000001, @h.result_set.matching_districts.last.entry[:high_school_graduation]
  end

  def test_does_kindergarten_variation_compare_to_median_householde_income
    assert_equal 0.766, @h.kindergarten_participation_against_household_income("ACADEMY 20")
  end

  def test_does_kindergarten_participation_correlates_with_household_income
    assert_equal true, @h.kindergarten_participation_correlates_with_household_income(for: "ACADEMY 20")
    assert_equal true, @h.kindergarten_participation_correlates_with_household_income(for: "COLORADO")
    assert_equal false, @h.kindergarten_participation_correlates_with_household_income(for: "STATEWIDE")
    assert_equal false, @h.kindergarten_participation_correlates_with_household_income(:across=>["ACADEMY 20","YUMA SCHOOL DISTRICT 1", 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
  end



end
