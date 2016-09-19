require "pry"
require_relative "../lib/load"
require_relative "../lib/data_scrub"
require_relative "enrollment"

class EnrollmentRepository
  attr_reader :enrollments
  include DataScrub

  def initialize
    @enrollments = []
  end

  def get_file_hash(file)
      Load.file_load(file)
  end

  def load_data(file)
    file[:enrollment].each do |key,value|
      data = get_file_hash(value)
      create_data(data, kindergarten_name(key))
    end
  end

  def kindergarten_name(key)
    key == :kindergarten ? key = :kindergarten_participation : key
  end

  def create_data(data, key)
    data.each do |row|
      enrollment = find_by_name(row[:location])
      is_enrollment_nil?(row, enrollment, key)
    end
  end

  def is_enrollment_nil?(row, enrollment, key)
    if enrollment.nil?
      create_enrollment(key, row)
    else
      enrollment.add_participation(create_numeric_data(row), key)
    end
  end

  def create_enrollment(key, row)
    @enrollments << Enrollment.new(enrollment_hash(key, row))
  end

  def create_numeric_data(data)
    { data[:timeframe].to_i => data[:data].to_f }
  end

  def enrollment_hash(key, data)
    {
      name: clean_name(data[:location]),
      key => create_numeric_data(data)
    }
  end


  def find_by_name(search_name)
    search_name = clean_name(search_name)
    found = @enrollments.find do |enrollment|
      enrollment if enrollment.data[:name] == search_name
    end
    return found
  end

end
