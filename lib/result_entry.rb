require "pry"

class ResultEntry
attr_reader :entry

  def initialize(data)
    @entry = {}
    add_to_entry(data)
  end

  def add_to_entry(data)
    entry.merge!(data)
  end

  def name
    entry[:name]
  end

  def free_and_reduced_price_lunch_rate
    entry[:free_and_reduced_price_lunch]
  end

  def children_in_poverty_rate
    entry[:children_in_poverty]
  end

  def high_school_graduation_rate
    entry[:high_school_graduation]
  end

  def median_household_income
    entry[:median_household_income]
  end


end
