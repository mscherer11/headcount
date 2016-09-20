require_relative '../lib/data_scrub'
require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/economic_profile'


class District
  include DataScrub

  attr_reader :name
  attr_accessor :enrollment, :statewide_test, :economic_profile

  def initialize(row)
    @name = row[:name] || DataScrub.clean_name(row[:location])
  end

end
