class UnknownDataError < StandardError
  attr_reader :message
  def initialize
    super
    @message = "Invalid input."
  end

  def errors(grade)
    raise UnknownDataError unless grade == :eighth_grade || grade == :third_grade
  end

  def errors_by_grade(subject, grade, year)
    raise UnknownDataError unless data[grade].has_key?(year)
    raise UnknownDataError unless data[grade][year].has_key?(subject)
  end

  def errors_by_race(subject, race, year)
    raise UnknownDataError unless data.has_key?(subject)
    raise UnknownDataError unless data[subject].has_key?(year)
    raise UnknownDataError unless data[subject][year].has_key?(race)
  end

end
