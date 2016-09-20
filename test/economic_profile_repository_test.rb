require_relative "test_helper"
require_relative "../../headcount/lib/economic_profile_repository"

class EconomicProfileRepositoryTest < Minitest::Test
  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
      }
    })
  end

  def test_create_instance_of_economic_repo
    assert_instance_of EconomicProfileRepository, @epr
  end

  def test_can_it_search_a_name
    ep = @epr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", ep.name
  end

  def test_loading_econ_profile_datas
    ["ACADEMY 20","WIDEFIELD 3","ROARING FORK RE-1","MOFFAT 2","ST VRAIN VALLEY RE 1J"].each do |dname|
      assert @epr.find_by_name(dname).is_a?(EconomicProfile)
    end
  end
end
