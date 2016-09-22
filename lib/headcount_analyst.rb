require_relative '../lib/district_repository'
require_relative '../lib/truncate'
require_relative '../lib/result_set'


class HeadcountAnalyst
  include Truncate
  attr_reader :result_entry, :result_set, :district_repo

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

  def kindergarten_participation_correlates_with_high_school_graduation(districts_list, original_method=nil)
    districts_list = district_parse(districts_list)
    if districts_list[0] == "STATEWIDE"
      districts_eval = @district_repo.districts
    else
      districts_eval = district_map(districts_list)
    end
    evaluate_districts(districts_eval, original_method)
  end

  def district_map(districts_list)
    districts_list.map do |district|
      @district_repo.find_by_name(district)
    end
  end

  def evaluate_districts(districts_eval, original_method)
    kinder_relates = districts_eval.map do |district|
      if original_method.nil?
        kindergarten_participation_against_high_school_graduation(district.name).between?(0.6,1.5)
      elsif original_method == "kindergarten_income"
        kindergarten_participation_against_household_income(district.name).between?(0.6,1.5)
      end
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

  def generic_search(districts, attribute, criteria)
    found = districts.select do |district|
      wrapped = average_wrapper(district, attribute)
       average_math(wrapped.values) > criteria
    end
  end

  def find_search_level(attribute, district)
    if attribute == :free_or_reduced_price_lunch
      district.economic_profile.data[attribute].values.to_h
    elsif
      district.economic_profile.data.has_key?(attribute)
      district.economic_profile.data[attribute].values
    elsif district.enrollment.data.has_key?(attribute)
      district.enrollment.data[attribute]
    end
  end

  def high_poverty_and_high_school_graduation
    statewide_average = find_entry("statewide_average")
    average_lunch = statewide_average.free_or_reduced_price_lunch_rate
    first_search = generic_search(@district_repo.districts, :free_or_reduced_price_lunch, average_lunch)
    average_poverty = statewide_average.children_in_poverty_rate
    second_search = generic_search(first_search, :children_in_poverty, average_poverty)
    average_grad_rate = statewide_average.high_school_graduation_rate
    final_search = generic_search(second_search, :high_school_graduation, average_grad_rate)
    create_district_entries(final_search)
  end

  def create_district_entries(districts)
    districts.each do |district|
      lunch = calculate_average_lunch(district)
      poverty = calculate_average_poverty(district)
      grad = calculate_average_grad(district)
      income = calculate_average_income(district)
      generate_matching_district(district.name,lunch,poverty,grad,income)
    end
  end

  def generate_matching_district(name,lunch,poverty,grad,income)
    data = {
      name: name,
      free_or_reduced_price_lunch: lunch,
      high_school_graduation: grad,
      children_in_poverty: poverty,
      median_household_income: income
    }
    create_matches(data)
  end

  def create_matches(data)
    result_set.add_matching_districts(ResultEntry.new(data))
  end

  def calculate_average_lunch(district)
      wrapped = average_wrapper(district, :free_or_reduced_price_lunch)
      lunch_average = average_math(wrapped.values)
  end

  def calculate_average_poverty(district)
    wrapped = average_wrapper(district, :children_in_poverty)
    poverty_average = average_math(wrapped.values)
  end

  def calculate_average_grad(district)
    wrapped = average_wrapper(district, :high_school_graduation)
    grad_average = average_math(wrapped.values)
  end

  def calculate_average_income(district)
    wrapped = average_wrapper(district, :median_household_income)
    income_average = average_math(wrapped.values)
  end

  def income_disparity
    statewide_average = find_entry("statewide_average")
    average_poverty = statewide_average.children_in_poverty_rate
    first_search = generic_search(@district_repo.districts, :children_in_poverty, average_poverty)
    average_income = statewide_average.median_household_income
    final_search = generic_search(first_search, :median_household_income, average_income)
    create_district_entries(final_search)
  end

  def kindergarten_participation_against_household_income(district_name)
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, against: 'COLORADO')
    economic_profile = district_repo.find_by_name(district_name).economic_profile
    economic_average = economic_profile.median_household_income_average
    economic_variation = economic_average/49705
    economic_variation == 0 ? 0 : shorten_float(kindergarten_variation/economic_variation)
  end

  def kindergarten_participation_correlates_with_household_income(districts_list)
    kindergarten_participation_correlates_with_high_school_graduation(districts_list, "kindergarten_income")
  end

end
