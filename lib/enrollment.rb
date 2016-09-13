class Enrollment

  def kindergarten_participation_by_year(data)
    return data
  end

  def kindergarten_participation_in_year(year)
    data = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    data.fetch(year)
  end

end
