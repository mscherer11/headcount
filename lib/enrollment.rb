class Enrollment
  attr_reader :name, :kindergarten_participation
  def initialize(stuff)
    @name = stuff[:name]
    @kindergarten_participation = stuff[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation.fetch(year)
  end

end
