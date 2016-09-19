require 'pry'
require_relative "../lib/economic_profile_repository"
require_relative '../lib/truncate'
require_relative "../lib/errors.rb"

class EconomicProfile
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
    medians = data[:median_household_income].map do |k,v|
      return v if year >= k[0] && year <= k[-1]
    end
    medians.reduce(:+)/medians.count
  end

end
