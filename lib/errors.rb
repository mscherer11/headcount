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

  def errors_by_year_median_house(year)
    unless data[:median_household_income].keys.flatten.include?(year)
      raise UnknownDataError
    end
  end

  def errors_by_year_lunch(year)
    unless data[:free_or_reduced_price_lunch].keys.include?(year)
      raise UnknownDataError
    end
  end

  def errors_by_poverty(year)
    unless data[:children_in_poverty].keys.include?(year)
      raise UnknownDataError
    end
  end

  def errors_by_title_i(year)
    unless data[:title_i].keys.include?(year)
      raise UnknownDataError
    end
  end
end
