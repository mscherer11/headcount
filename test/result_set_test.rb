require_relative 'test_helper.rb'
require_relative "../../headcount/lib/result_set"
require_relative "../../headcount/lib/result_entry"

class ResultSetTest < Minitest::Test

  def setup
    @r1 = ResultEntry.new({name: "test1", free_or_reduced_price_lunch: 0.5,
      children_in_poverty: 0.25,
      high_school_graduation: 0.75})
    @r2 = ResultEntry.new({name:"test2", free_or_reduced_price_lunch: 0.3,
      children_in_poverty: 0.2,
      high_school_graduation: 0.6})

    @rs = ResultSet.new
    @rs.add_matching_districts(@r1)
    @rs.add_matching_districts(@r2)
  end

  def test_does_matching_district_contain_result_entry_class
    assert_instance_of ResultEntry, @rs.matching_districts.first
  end

  def test_does_matching_districit_populate
    assert_equal 2, @rs.matching_districts.count
  end

  def test_can_we_access_the_values

    assert_equal 0.5, @rs.matching_districts.first.free_or_reduced_price_lunch_rate
    assert_equal 0.25, @rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.75, @rs.matching_districts.first.high_school_graduation_rate
  end

  def test_can_we_access_the_name
    assert_equal "test1", @rs.matching_districts.first.name
    assert_equal "test2", @rs.matching_districts[1].name
  end

end
