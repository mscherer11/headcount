require_relative '../lib/district_repository'
require_relative '../lib/truncate'

class HeadcountAnalyst
  include Truncate

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(subject1, subject2)
    numerator_hash = sum_numerator(subject1)
    denominator_hash = sum_denominator(subject2)

    numerator = numerator_hash.values.reduce(:+)/numerator_hash.length
    denominator = denominator_hash.values.reduce(:+)/denominator_hash.length

    shorten_float(numerator/denominator)
  end

  def kindergarten_participation_rate_variation_trend(subject1, subject2)
    numerator_hash = sum_numerator(subject1)
    denominator_hash = sum_denominator(subject2)

    trended_results = Hash.new
    numerator_hash.each do |k,v|
      trended_results = ({k => shorten_float(v / denominator_hash[k])}).merge!(trended_results)
    end
    return trended_results.sort.to_h
  end

  def sum_numerator(subject1)
    numerator_hash = @district_repo.find_by_name(subject1).enrollment.kindergarten_participation_by_year
  end

  def sum_denominator(subject2)
    denominator_hash = @district_repo.find_by_name(subject2[:against]).enrollment.kindergarten_participation_by_year
  end

end
