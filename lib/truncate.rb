require 'pry'

module Truncate

  def shorten_float(x)
    (x * 1000).floor / 1000.0
  end

end
