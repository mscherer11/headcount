require 'pry'
require_relative "../lib/data_scrub"
require_relative "../lib/errors"
require_relative "../lib/load"
require_relative "../lib/economic_profile_repository"
require_relative "../lib/result_entry"


class ResultSet
  attr_reader :result_entries, :raw

  def initialize
    @result_entries = Array.new
    @raw = Hash.new
  end

  def load_data(file)
    file.each do |key,value|
      data = get_file_data(value)
      find_raw_data(data, key)
    end
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
    { row[:location] =>
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

end
