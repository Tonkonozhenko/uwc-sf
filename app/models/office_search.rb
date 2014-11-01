class OfficeSearch
  attr_accessor :city, :street

  def initialize(opts = {})
    opts ||= {}
    self.city = opts[:city]
    self.street = opts[:street]
  end
end