class OfficeSearch < Search
  def search
    @offices ||= search_offices
  end

  def search!
    search_offices
  end

  private
  def search_offices
    transform_city
    transform_street

    url = URI.escape("https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&pboffice&city=#{city}&address=#{street}")
    doc = Nokogiri::HTML(open(url))
    @offices = doc.css('pboffice pboffice').map do |d|
      PbOffice.new(*PbOffice::ATTRIBUTES.map { |a| d.attr(a) })
    end
    @offices.sort_by! { |office| office.city.mb_chars.downcase.to_s == city.mb_chars.downcase.to_s ? -1 : 0 }
    @offices
  end
end