require 'csv'
module Load
  extend self

  def file_load(file_name)
    file = CSV.open file_name, headers: true, header_converters: :symbol
    return file_name
  end

end
