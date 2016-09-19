module DataScrub
  extend self

  def clean_name(information)
    information.upcase
  end

  def clean_data(data)
    data.to_f
  end

end
