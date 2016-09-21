require 'pry'
require_relative "../lib/data_scrub"
require_relative "../lib/errors"
require_relative "../lib/load"
require_relative "../lib/economic_profile_repository"
require_relative "../lib/result_entry"


class ResultSet
  include DataScrub
  attr_reader :result_entries, :raw

  def initialize
    @result_entries = Array.new
    @raw = Hash.new
  end

  def load_data(file)
    file.each do |key,value|
      data = get_file_data(value)
      wrap_average_and_result_set_creation(data, key)
    end
  end

  def wrap_average_and_result_set_creation(data, key)
    find_raw_data(data, key)
    create_or_add_entries(data, key)
  end

  def create_or_add_entries(data, key)
    district_names = get_district_names(key)
    district_names.each do |district|
      find_district = find_by_name(district)
      average = district_average(key, district)
      if find_district.nil?
        create_result_entries(key, average, district)
      else
        find_district.combine_data(key, average, district)
      end
    end
  end

  def get_district_names(key)
    raw[key].keys
  end

  def create_result_entries(key, average, name)
    result_entries << ResultEntry.new(combine_averages_and_keys(key, average), name)
  end

  def combine_averages_and_keys(key, average)
    { key => average }
  end

  def get_file_data(file)
    Load.file_load(file)
  end

  def find_raw_data(data, key)
    data.each do |row|
      next if determine_row_creation(row)
      add_raw(key, row)
    end
  end

  def determine_row_creation(row)
    if row[:poverty_level] == "Eligible for Reduced Price Lunch" || row[:poverty_level] == "Eligible for Free Lunch"
      true
    elsif row[:dataformat] == "Number"
      true
    else
      false
    end
  end

  def raw_data(row)
    { clean_name(row[:location]) =>
      { row[:timeframe] => row[:data].to_f }
    }
  end

  def add_raw(key, row)
    new_data = raw_data(row)
    search_key = new_data.keys.first
    if raw.empty? || raw.has_key?(key) == false
      set_raw_data(key, row)
    elsif raw[key].has_key?(search_key)
      raw[key][search_key].merge!(new_data.values.first)
    else
      raw[key].merge!(new_data)
    end
  end

  def set_raw_data(key, row)
    raw.merge!({ key => raw_data(row) })
  end

  def district_average(key, district)
    values_to_average = raw[key][district].values
    values_to_average.reduce(:+)/values_to_average.count
  end

  def find_by_name(search_name)
    search_name = clean_name(search_name)
    result_entries.find do |result_entry|
      result_entry if result_entry.name == search_name
    end
  end

  def matching_districts(attribute, criteria)
    result_entries.select do |entry|
      entry.send(attribute) == criteria
    end
  end

  def statewide_average(attribute)
    find_values = raw[attribute.to_sym].values
    average_numbers = find_values.map do |value|
      extract_values_for_average(value)
    end
    average_numbers = average_numbers.flatten
    average_numbers.reduce(:+)/average_numbers.count
  end

  def extract_values_for_average(value)
    value.map do |k,v|
      v
    end
  end

  def high_poverty_and_high_school_graduation
    average_lunch = statewide_average(:free_or_reduced_price_lunch)
    average_poverty = statewide_average(:children_in_poverty)
    average_grad_rate = statewide_average(:high_school_graduation)
    result_entries.select do |entry|
      if entry.data[:free_or_reduced_price_lunch].nil? || entry.data[:children_in_poverty].nil? || entry.data[:high_school_graduation].nil?
          next
      elsif
        binding.pry
        entry.data[:free_or_reduced_price_lunch] > average_lunch && entry.data[:children_in_poverty] > average_poverty && entry.data[:high_school_graduation] > average_grad_rate
      end
    end
    binding.pry

  end


end
