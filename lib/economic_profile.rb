require 'pry'
require_relative "../lib/economic_profile_repository"
require_relative '../lib/truncate'
require_relative "../lib/errors.rb"

class EconomicProfile < UnknownDataError

  attr_reader :data

  def initialize(data=nil)
    @data = data
  end

  def add_testing(row, key)
    if data[key] == nil
      data.merge!({key=>row})
    elsif data[key].has_key?(row.keys.first)
      data[key][row.keys.first].merge!(row[row.keys.first])
    else
      data[key].merge!(row)
    end
  end

  def name
    data[:name]
  end

  def median_household_income_in_year(year)
    errors_by_year_median_house(year)
    medians = data[:median_household_income].map do |k,v|
      v if year >= k[0] && year <= k[-1]
    end
    medians.include?(nil) ?  medians[0].to_i : medians.reduce(:+)/medians.count
  end

  def median_household_income_average
    average = data[:median_household_income].map do |k,v|
            v
    end
    average.reduce(:+)/average.count
  end

  def children_in_poverty_in_year(year)
    errors_by_poverty(year)
    data[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    errors_by_year_lunch(year)
    data[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    errors_by_year_lunch(year)
    data[:free_or_reduced_price_lunch][year][:total]
  end

  def title_i_in_year(year)
    errors_by_title_i(year)
    data[:title_i][year]
  end

end
