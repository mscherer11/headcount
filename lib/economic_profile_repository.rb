require 'pry'
require_relative "../lib/economic_profile"
require_relative "../lib/data_scrub"
require_relative "../lib/errors"
require_relative "../lib/load"
require_relative "../lib/creation_module"


class EconomicProfileRepository
  include DataScrub
  attr_reader :economic_profiles


  def initialize
    @economic_profiles = Array.new
  end

  def load_data(file)
    file[:economic_profile].each do |key,value|
      data = get_file_data(value)
      create_data(data, key)
    end
  end

  def get_file_data(file)
    Load.file_load(file)
  end

  def create_data(data, key)
    data.each do |row|
      next if determine_row_creation(row, key)
      economic_profile = find_by_name(row[:location])
      is_profile_nil?(row, economic_profile, key)
    end
  end

  def determine_row_creation(row, key)
    if key == :children_in_poverty && row[:dataformat] == "Number"
      true
    elsif row[:poverty_level] == "Eligible for Reduced Price Lunch" || row[:poverty_level] == "Eligible for Free Lunch"
      true
    else
      false
    end
  end

  def is_profile_nil?(row, economic_profile, key)
    if economic_profile.nil?
      create_profiles(key, row)
    else
      economic_profile.add_testing(create_numeric_data(row, key), key)
    end
  end

  def create_profiles(key, row)
    economic_profiles << EconomicProfile.new(economic_profile_hash(key, row))
  end

  def economic_profile_hash(key, data)
    {
      name: DataScrub.clean_name(data[:location]),
      key => create_numeric_data(data, key)
    }
  end

  def create_numeric_data(data, key)
    {
      determine_key_creation(data, key) => determine_branch(data, key)
    }
  end

  def determine_branch(data, key)
    if key == :free_or_reduced_price_lunch
      {convert_lunch_keys(data) => determine_value_branch(data)}
    else
      determine_value_creation(data, key)
    end
  end

  def determine_value_branch(data)
    return data_int(data) if data[:dataformat] == :total
    return data_float(data) if data[:dataformat] == :percentage
  end

  def determine_value_creation(data, key)
    return data_int(data) if key == :median_household_income
    return data_float(data) if key == :children_in_poverty
    return data_float(data) if key == :title_i
  end

  def data_float(data)
    data[:data].to_f
  end

  def data_int(data)
    data[:data].to_i
  end

  def determine_key_creation(data,key)
    return convert_date_range(data) if key == :median_household_income
    return data[:timeframe].to_i if key == :children_in_poverty || :title_i
  end

  def convert_date_range(data)
    data[:timeframe].split("-").map! {|num| num.to_i}
  end

  def convert_lunch_keys(data)
    if data[:dataformat] == "Percent"
      data[:dataformat] = :percentage
    elsif data[:dataformat] == "Number"
        data[:dataformat] = :total
    end
  end

  def find_by_name(search_name)
    search_name = DataScrub.clean_name(search_name)
    found = @economic_profiles.find do |economic_profile|
      economic_profile if economic_profile.data[:name] == search_name
    end
    return found
  end

end
