require "pry"
require_relative "../lib/load"
require_relative "../lib/data_scrub"
require_relative "enrollment"

class EnrollmentRepository
  attr_reader :enrollments


  def initialize
    @enrollments = []
  end

  def get_file_hash(file)
    Load.file_load(file[:enrollment][:kindergarten])
  end

  def load_data(file)
    data = get_file_hash(file)
    data.each do |row|
      enrollment = find_by_name(row[:location])
      is_enrollment_nil?(row, enrollment)
    end
  end

  def is_enrollment_nil?(row, enrollment)
    if enrollment.nil?
      create_enrollment(row)
    else
      enrollment.add_participation(kindergarten_participation(row))
    end
  end

  def create_enrollment(row)
    @enrollments << Enrollment.new(enrollment_hash(row))
  end

  def kindergarten_participation(data)
    { data[:timeframe].to_i => data[:data].to_f }
  end

  def enrollment_hash(data)
    {
      name: DataScrub.clean_name(data[:location]),
      kindergarten_participation: kindergarten_participation(data)
    }
  end


  def find_by_name(search_name)
    search_name = DataScrub.clean_name(search_name)
    found = @enrollments.find do |enrollment|
      enrollment if enrollment.data[:name] == search_name
    end
    return found
  end

end
