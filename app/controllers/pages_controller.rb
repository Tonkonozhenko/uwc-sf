require 'open-uri'

class PagesController < ApplicationController
  before_filter only: [:offices_search, :bonus_plus_search] do
    urls = {
        offices: 'https://api.privatbank.ua/p24api/pubinfo?exchange&coursid=5',
        cards: 'https://api.privatbank.ua/p24api/pubinfo?cardExchange',
        # Uncomment this to use national bank course
        national: 'https://api.privatbank.ua/p24api/pubinfo?exchange&coursid=3',
    }

    @courses = urls.inject({}) do |h, (k, url)|
      doc = Nokogiri::HTML(open(url))
      h[k] = doc.css('exchangerate').inject({}) do |hsh, element|
        hsh[element.attr('ccy').downcase.to_sym] = [element.attr('buy'), element.attr('sale')].map(&:to_f)
        hsh
      end
      h
    end
  end

  def offices_search

  end

  def bonus_plus_search

  end
end
