require "pry"

class ResultEntry

attr_reader :name, :data

  def initialize(data, name)
    @data = data
    @name = name
  end

  def combine_data(key, average, district_name)
    data.merge!(key=>average)
  end

  def free_or_reduced_price_lunch_rate
    data[:free_or_reduced_price_lunch]
  end

  def children_in_poverty_rate
    data[:children_in_poverty]
  end

  def high_school_graduation_rate
    data[:high_school_graduation]
  end

  def median_household_income
    data[:median_household_income]
  end

end
