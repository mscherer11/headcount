module DataScrub
  extend self

  def clean_name(information)
    information.upcase
  end

  def clean_data(data)
    data.to_f
  end

  def scrub_key(key)
    key_sub_space = key.gsub!(" ","_")
    key_sub_slash = key.gsub!("/","_")
    if key_sub_slash != nil
      key_sub_slash.downcase.to_sym
    elsif key_sub_space != nil
      key_sub_space.downcase.to_sym
    else
      key.downcase.to_sym
    end
  end

end
