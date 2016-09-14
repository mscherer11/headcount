require_relative '../lib/data_scrub'
require_relative '../lib/enrollment_repository'


class District
  include DataScrub

  attr_reader :name
  attr_accessor :enrollment

  def initialize(row)
    @name = row[:name] || DataScrub.clean_name(row[:location])
    @enrollment = nil
  end

end
