require_relative '../lib/district_repository'
require_relative '../lib/truncate'
require_relative '../lib/result_set'


class HeadcountAnalyst
  include Truncate
  attr_reader :result_entry, :result_set

  def initialize(district_repo)
    @district_repo = district_repo
    @result_set = ResultSet.new
  end

  def kindergarten_participation_rate_variation(subject1, subject2)
    rate_variation(subject1, subject2, "kindergarten_participation_by_year")
  end

  def high_school_graduation_rate_variation(subject1, subject2)
    rate_variation(subject1, subject2, "graduation_rate_by_year")
  end

  def rate_variation(subject1, subject2, attribute)
    num_hash = sum_numerator(subject1).send(attribute)
    denom_hash = sum_denominator(subject2).send(attribute)
    numerator = num_hash.values.reduce(:+)/num_hash.length
    denominator = denom_hash.values.reduce(:+)/denom_hash.length
    shorten_float(numerator/denominator)
  end

  def kindergarten_participation_rate_variation_trend(subject1, subject2)
    num_hash = sum_numerator(subject1).kindergarten_participation_by_year
    denom_hash = sum_denominator(subject2).kindergarten_participation_by_year
    trended_results = Hash.new
    num_hash.each do |k,v|
      trended_results =
      ({k => shorten_float(v / denom_hash[k])}).merge!(trended_results)
    end
    return trended_results.sort.to_h
  end

  def sum_numerator(subject1)
    num_hash = @district_repo.find_by_name(subject1).enrollment
  end

  def sum_denominator(subject2)
    denom_hash = @district_repo.find_by_name(subject2[:against]).enrollment
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder = kindergarten_participation_rate_variation(district, against: 'COLORADO')
    high_school = high_school_graduation_rate_variation(district, against: 'COLORADO')
    high_school == 0 ? 0 : shorten_float(kinder / high_school)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(districts_list)
    districts_list = district_parse(districts_list)
    if districts_list[0] == "STATEWIDE"
      districts_eval = @district_repo.districts
    else
      districts_eval = district_map(districts_list)
    end
    evaluate_districts(districts_eval)
  end

  def district_map(districts_list)
    districts_list.map do |district|
      @district_repo.find_by_name(district)
    end
  end

  def evaluate_districts(districts_eval)
    kinder_relates = districts_eval.map do |district|
      kindergarten_participation_against_high_school_graduation(district.name).between?(0.6,1.5)
    end
    above_70_percent?(kinder_relates)
  end

  def district_parse(district)
    district.values.flatten
  end

  def above_70_percent?(data)
    percentage = data.count(true).to_f/data.length.to_f
    percentage > 0.7 ? true : false
  end

  def calculate_statewide_average(attribute)
    districts = @district_repo.districts
    averages = districts.map do |district|
      wrapped = average_wrapper(district, attribute)
      average_math(wrapped.values)
    end
    create_entry_hash(attribute, average_math(averages), "statewide_average")
    average_math(averages)
  end

  def average_wrapper(district, attribute)
    found = {}
    counter = 0
    if attribute == :free_or_reduced_price_lunch
      district.economic_profile.data[attribute].values.each do |val|
        found.merge!(counter => val[:percentage])
        counter += 1
      end
      found
    elsif district.economic_profile.data.has_key?(attribute)
      district.economic_profile.data[attribute]
    elsif district.enrollment.data.has_key?(attribute)
      district.enrollment.data[attribute]
    else
      {0=>0}
    end
  end

  # def attribute_sort(district,attribute,found,counter)
  #   district.economic_profile.data[attribute].values.each do |val|
  #     found.merge!(counter => val[:percentage])
  #     counter += 1
  #   end
  #   found
  # end

  def average_math(wrapped)
    wrapped.reduce(:+)/wrapped.count
  end

  def create_entry_hash(attribute, data, name)
    entry = find_entry(name)
    if entry.nil?
      create_entries(attribute, data, name)
    else
      entry.add_to_entry({attribute=>data})
    end
  end

  def create_entries(attribute, data, name)
    result_set.add_matching_districts(ResultEntry.new({
      name: name,
      attribute => data}))
  end

  def find_entry(name)
    result_set.matching_districts.find do |result|
      result.entry[:name]
    end
  end

  def high_poverty_and_high_school_graduation
    
  end

end
