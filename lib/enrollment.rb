class Enrollment
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def kindergarten_participation_by_year
    data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    data[:kindergarten_participation][year]
  end

  def add_participation(row, key)
    if data[key] == nil
      data.merge!({key=>row})
    else
      data[key].merge!(row)
    end
  end

  def name
    data[:name]
  end

end
