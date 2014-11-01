class Search
  attr_accessor :city, :street

  def initialize(opts = {})
    opts ||= {}
    self.city = opts[:city]
    self.street = opts[:street]
  end

  private
  def transform_street
    self.street = street.mb_chars.downcase.to_s
    {
        'Академика ' => ' ',
        ' Академика' => ' ',
        'улица ' => '',
        ' улица' => '',
        'ул ' => '',
        ' ул' => '',
        'проспект ' => '',
        ' проспект' => '',
        'пр ' => '',
        ' пр' => '',
        'переулок ' => '',
        ' переулок' => '',
        'пер ' => '',
        ' пер' => '',
        'площадь ' => '',
        ' площадь' => '',
        'пл ' => '',
        ' пл' => '',
        'бульвар ' => '',
        ' бульвар' => '',
        'бул ' => '',
        ' бул' => '',
    }.each { |k, v| street.gsub!(k, v) }
    street.strip!
  end

  def transform_city
    self.city = city.mb_chars.downcase.to_s
    {
        '.' => ' ',
        'город ' => '',
        ' город' => '',
        'г ' => '',
        ' г' => '',
        'село ' => '',
        ' село' => '',
        'с ' => '',
        ' с' => '',
    }.each { |k, v| city.gsub!(k, v) }
    city.strip!
  end
end