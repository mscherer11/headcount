require_relative '../lib/data_scrub'
require_relative '../lib/enrollment_repository'


class District
  include DataScrub

  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(row)
    @name = row[:name] || DataScrub.clean_name(row[:location])
    @enrollment = nil
    @statewide_test = nil
  end

end
