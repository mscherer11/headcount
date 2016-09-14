require "pry"
require_relative "../lib/load"
require_relative "../lib/data_scrub"
require_relative "district"
require_relative "enrollment_repository"


class DistrictRepository
  include Load

  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(file)
    data = Load.file_load(file[:enrollment][:kindergarten])
    data.each do |row|
      create_district(row) unless find_by_name(row[:location])
    end
    @enrollment_repo.load_data(file)
    find_enrollments
  end

  def create_district(row)
    districts << District.new(row)
  end

  def find_by_name(search_name)
    search_name = DataScrub.clean_name(search_name)
    found = districts.find do |district|
      district if district.name == search_name
    end
    return found
  end

  def find_all_matching(search_data)
    search_data = DataScrub.clean_name(search_data)
    found_districts = []
    districts.each do |district|
      found_districts << district if district.name.scan(search_data).length > 0
    end
    return found_districts
  end

  def find_enrollments
    districts.each do |district|
      district.enrollment = enrollment_repo.find_by_name(district.name)
    end
  end

end
