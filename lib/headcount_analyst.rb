require_relative '../lib/district_repository'
require_relative '../lib/truncate'

class HeadcountAnalyst
  include Truncate

  def initialize(district_repo)
    @district_repo = district_repo
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
    shorten_float(kinder / high_school)
  end

end
