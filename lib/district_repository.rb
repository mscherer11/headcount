require "pry"
require_relative "../lib/load"
require_relative "../lib/data_scrub"
require_relative "district"

class DistrictRepository
  include Load

  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(file)
    binding.pry
    data = Load.file_load(file[:enrollment][:kindergarten])
    data.each do |row|
      create_district(row) unless find_by_name(row[:location])
    end
  end

  def create_district(row)
    @districts << District.new(row)
  end

  def find_by_name(search_name)
    search_name = DataScrub.clean_name(search_name)
    found = @districts.find do |district|
      district if district.name == search_name
    end
    return found
  end

  def find_all_matching(search_data)
    search_data = DataScrub.clean_name(search_data)
    found_districts = []
    @districts.each do |district|
      found_districts << district if district.name.scan(search_data).length > 0
    end
    return found_districts
  end


end
