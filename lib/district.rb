require_relative '../lib/data_scrub'


class District
  include DataScrub

  attr_reader :name

  def initialize(row)
    @name = DataScrub.clean_name(row[:location])
  end

end
