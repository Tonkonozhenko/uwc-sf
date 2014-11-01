class OfficeSearch
  attr_accessor :city, :street

  def initialize(opts = {})
    opts ||= {}
    self.city = opts[:city]
    self.street = opts[:street]
  end

  def search
    @offices ||= search_offices
  end

  def search!
    search_offices
  end

  private
  def search_offices
    url = URI.escape("https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&pboffice&city=#{city}&address=#{street}")
    doc = Nokogiri::HTML(open(url))
    @offices = doc.css('pboffice pboffice').map do |d|
      PbOffice.new(*PbOffice::ATTRIBUTES.map { |i| d.attr(i) })
    end
  end
end