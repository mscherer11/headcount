
require_relative 'test_helper.rb'
require_relative "../../headcount/lib/errors"

class ErrorsTest < Minitest::Test
  def setup
    @error = UnknownDataError.new
    @data = {:third_grade=>
  {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
   2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
   2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
   2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
   2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517},
   2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687},
   2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}}
  end

  def test_general_grade_errors
    exception = assert_raises UnknownDataError do
      @error.errors(:fourth_grade)
    end
    assert_equal("Invalid input.",exception.message)

    exception = assert_raises UnknownDataError do
      @error.errors(7)
    end
    assert_equal("Invalid input.",exception.message)

    exception = assert_raises UnknownDataError do
      @error.errors(":eighth_grade")
    end
    assert_equal("Invalid input.",exception.message)
  end

  def test_errors_by_grade
   exception = assert_raises UnknownDataError do
      @error.errors_by_grade(@data[:third_grade],@data[:reading], @data[1990])
    end
    assert_equal("Invalid input.",exception.message)

  end


end
