require_relative "../lib/statewide_test_repository"
require_relative '../lib/truncate'
require_relative "../lib/errors.rb"

class StatewideTest < UnknownDataError
  include Truncate
  attr_reader :data

  def initialize(data=nil)
    @data = data
  end

  def add_testing(row, key)
    if data[key] == nil
      data.merge!({key=>row})
    elsif data[key].has_key?(row.keys.first)
      data[key][row.keys.first].merge!(row[row.keys.first])
    else
      data[key].merge!(row)
    end
  end

  def proficient_by_grade(grade)
    grade = convert_grade_to_sym(grade)
    errors(grade)
    final = {}
    data[grade].each do |key,val|
      conversion = trunc_grades(val)
      final.merge({key=>conversion})
    end
  end

  def convert_grade_to_sym(grade)
    return :third_grade if grade == 3
    return :eighth_grade if grade == 8
  end

  def trunc_grades(val)
    present_data = Hash.new
    trunc_values = val.map do |k, v|
      val[k] = shorten_float(v)
      present_data.merge!({k=>val[k]})
    end
    trunc_values
  end

  def proficient_by_race_or_ethnicity(race)
    subject_keys = data.keys[3..-1]
    years = create_year_keys(subject_keys)
    final = {}
    years.each do |year|
      final.merge!({year=>create_inner_hash(subject_keys,year,race)})
    end
    final
  end

  def create_inner_hash(subject_keys, year, race)
    inner_values = {}
    subject_keys.each do |subject|
      lowest_value = {subject=>get_lowest_hash_values(data[subject], year, race)}
      inner_values.merge!(lowest_value)
    end
    inner_values
  end

  def get_lowest_hash_values(data, year, race)
    shorten_float(data[year][race])
  end

  def create_year_keys(subject_keys)
    year_keys = subject_keys.map do |key|
      temp_keys = data[key].keys
    end
    year_keys = year_keys.sort.flatten.uniq
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    error_wrapper(subject, grade, year)
    value = proficient_by_grade(grade)[year][subject]
    value == 0.0 ? value = "N/A": value
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    errors_by_race(subject, race, year)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end

  def error_wrapper(subject, grade, year)
    grade = convert_grade_to_sym(grade)
    errors_by_grade(subject, grade, year)
  end

end
