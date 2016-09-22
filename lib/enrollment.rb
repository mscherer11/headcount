require_relative '../lib/truncate'

class Enrollment
  include Truncate
  attr_reader :data, :name

  def initialize(data)
    @data = data
    @name = data[:name]
  end

  def kindergarten_participation_by_year
    data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    data[:kindergarten_participation][year]
  end

  def add_participation(row, key)
    data[key].nil? ? data.merge!({key=>row}) : data[key].merge!(row)
  end

  def graduation_rate_in_year(year)
    shorten_float(data[:high_school_graduation][year])
  end

  def graduation_rate_by_year
    data[:high_school_graduation].map do |key,val|
      [key,shorten_float(val)]
    end.to_h
  end

end
