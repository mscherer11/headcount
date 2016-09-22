require "pry"
require_relative "../lib/load"
require_relative "../lib/data_scrub"
require_relative "district"
require_relative "enrollment_repository"
require_relative "statewide_test_repository"
require_relative "economic_profile_repository"


class DistrictRepository
  include Load

  attr_reader :districts, :enrollment_repo, :statewide_test_repository, :economic_profile_repository

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
    @statewide_test_repository = StatewideTestRepository.new
    @economic_profile_repository = EconomicProfileRepository.new
  end

  def load_data(file)
    data = Load.file_load(file[:enrollment][:kindergarten])
    data.each do |row|
      create_district(row) unless find_by_name(row[:location])
    end
    enrollment_load(file)
    statewide_load(file)
    economic_profile_load(file)
  end

  def enrollment_load(file)
    @enrollment_repo.load_data(file)
    find_enrollments
  end

  def statewide_load(file)
    @statewide_test_repository.load_data(file) if file.has_key?(:statewide_testing)
    find_statewide_testing
  end

  def economic_profile_load(file)
    @economic_profile_repository.load_data(file) if file.has_key?(:economic_profile)
    find_economic_profiles
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
    found_districts = districts.map do |district|
      district if district.name.scan(search_data).length > 0
    end
    return found_districts
  end

  def find_enrollments
    districts.each do |district|
      district.enrollment = enrollment_repo.find_by_name(district.name)
    end
  end

  def find_statewide_testing
    districts.each do |district|
      district.statewide_test = statewide_test_repository.find_by_name(district.name)
    end
  end

  def find_economic_profiles
    districts.each do |district|
      district.economic_profile = economic_profile_repository.find_by_name(district.name)
    end
  end

end
