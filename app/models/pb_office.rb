class PbOffice
  include ActiveModel::Serialization

  ATTRIBUTES = %i[city address name phone email]
  attr_accessor *ATTRIBUTES

  def initialize(city = nil, address = nil, name = nil, phone = nil, email = nil)
    @city = city
    @address = address
    @name = name
    @phone = phone
    @email = email
  end
end