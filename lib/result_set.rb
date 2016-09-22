require 'pry'
require_relative "../lib/result_entry"
require_relative "../lib/district_repository"

class ResultSet
  include DataScrub

  attr_reader :matching_districts

  def initialize
    @matching_districts = Array.new
  end

  def add_matching_districts(argument)
    matching_districts << argument
  end

  def statewide_average
    find_entry(statewide_average)
  end

  def find_entry(name)
    matching_districts.find do |result|
      result.entry[:name]
    end
  end

end
