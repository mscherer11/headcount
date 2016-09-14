require 'csv'
module Load
  extend self

  def file_load(file_name)
    file = CSV.open file_name.to_s, headers: true, header_converters: :symbol
    return file
  end

end
