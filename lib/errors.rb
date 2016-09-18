class UnknownDataError < StandardError
  def initialize
    super
  end

  def errors(grade)
    raise UnknownDataError unless grade == 3 || grade == 8
  end

  def errors_by_grade(subject, grade, year)
    errors(grade)
    raise UnknownDataError unless data[grade].has_key?(year)
    raise UnknownDataError unless data[grade][year].has_key?(subject)
  end

  def errors_by_race(subject, race, year)
    errors(grade)
    raise UnknownDataError unless data.has_key?(subject)
    raise UnknownDataError unless data[subject].has_key?(year)
    raise UnknownDataError unless data[subject][year].has_key?(race)
  end

end
