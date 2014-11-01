class BonusPlusSerializer < ActiveModel::Serializer
  attributes *BonusPlus::ATTRIBUTES

  def bonus_plus
    ApplicationController.helpers.number_with_precision(object.bonus_plus, precision: 2)
  end
end
