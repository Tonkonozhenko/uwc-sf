class BonusPlusSearch < Search
  attr_accessor :type, :state
  TYPES = []
  STATES = []

  def initialize(opts = {})
    opts ||= {}
    self.city = opts[:city]
    self.street = opts[:street]
    self.type = opts[:type]
    self.state = opts[:state]
  end

  def search
    @bonuses ||= search_bonuses
  end

  def search!
    search_bonuses
  end

  private
  def search_bonuses
    transform_city
    transform_street

    url = URI.escape("https://privat24.privatbank.ua/p24/accountorder?oper=prp&bonus&PUREXML=&state=#{state}&city=#{city}&address=#{street}&type=#{type}")
    doc = Nokogiri::HTML(open(url))
    @bonuses = doc.css('bonus bonus').map do |d|
      BonusPlus.new(*BonusPlus::ATTRIBUTES.map { |a| d.attr(a) })
    end
    @bonuses.sort_by! do |bonus|
      bonus.city.downcase.mb_chars.downcase.to_s == city.mb_chars.downcase.to_s ? -1 : 0
    end
    @bonuses
  end
end