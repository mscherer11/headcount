require_relative "../lib/statewide_test"
require_relative "../lib/truncate"


class StatewideTestRepository
  include Truncate
  attr_reader :statewide

  def initialize
    @statewide = Array.new
  end

  def load_data(file)
    file[:statewide_testing].each do |key,value|
      data = get_file_data(value)
      create_data(data, key)
    end
  end

  def get_file_data(file)
    Load.file_load(file)
  end

  def create_data(data, key)
    data.each do |row|
      statewide_test = find_by_name(row[:location])
      is_statewide_nil?(row, statewide_test, key)
    end
  end

  def is_statewide_nil?(row, statewide_test, key)
    if statewide_test.nil?
      create_statewide(key, row)
    else
      statewide_test.add_testing(create_numeric_data(row), key)
    end
  end

  def create_statewide(key, row)
    @statewide << StatewideTest.new(statewide_testing_hash(key, row))
  end

  def statewide_testing_hash(key, data)
    {
      name: DataScrub.clean_name(data[:location]),
      key => create_numeric_data(data)
    }
  end

  def create_numeric_data(data)
    {
      data[:timeframe].to_i =>
      {
        score_or_race(data) => data[:data].to_f
      }
    }
  end

  def score_or_race(data)
    return scrub_key(data[:score]) if data[:score] != nil
    return scrub_key(data[:race_ethnicity]) if data[:race_ethnicity] != nil
  end

  def find_by_name(search_name)
    search_name = DataScrub.clean_name(search_name)
    found = @statewide.find do |statewide_test|
      statewide_test if statewide_test.data[:name] == search_name
    end
    return found
  end

end
