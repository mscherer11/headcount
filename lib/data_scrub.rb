module DataScrub
  extend self

  def clean_name(information)
    information.upcase
  end

  def clean_data(data)
    data.to_f
  end

  def scrub_key(key)
    key.gsub(/[\W]/,"_").downcase.to_sym
    # key.downcase.to_sym
  end

end
