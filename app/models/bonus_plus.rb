class BonusPlus
  include ActiveModel::Serialization

  ATTRIBUTES = %i[city address type bonus_plus]
  attr_accessor *ATTRIBUTES

  def initialize(city = nil, address = nil, type = nil, bonus_plus = nil)
    @city = city
    @address = address
    @type = type
    @bonus_plus = bonus_plus
  end
end