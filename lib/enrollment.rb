class Enrollment
  attr_reader :data

  def initialize(data)
    # @name = data[:name] #add test it scrubs name
    # @kindergarten_participation = data[:kindergarten_participation]
    @data = hashify(data)
  end

  def hashify(data)
    {
      name: data[:name],
      kindergarten_participation: data[:kindergarten_participation]
    }
  end

  def kindergarten_participation_by_year
    data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    data[:kindergarten_participation][year]
  end

  def add_participation(row)
    data[:kindergarten_participation].merge!(row)
  end

  def name
    data[:name]
  end

end
