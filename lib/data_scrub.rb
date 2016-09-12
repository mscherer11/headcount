module DataScrub
  extend self

  def regex_name
    /\w+/
  end

  def clean_name(information)
    information.to_s.gsub(regex_name) {|word| word.upcase!}
  end

  def clean_data(data)
    data.to_f
  end

end
