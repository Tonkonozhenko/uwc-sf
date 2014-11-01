class PagesController < ApplicationController
  respond_to :html, :json

  before_filter only: [:office_search, :bonus_plus_search] do
    urls = {
        offices: 'https://api.privatbank.ua/p24api/pubinfo?exchange&coursid=5',
        cards: 'https://api.privatbank.ua/p24api/pubinfo?cardExchange',
        # Uncomment this to use national bank course
        # national: 'https://api.privatbank.ua/p24api/pubinfo?exchange&coursid=3',
        national: 'https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ua'
    }

    @courses = urls.inject({}) do |h, (k, url)|
      doc = Nokogiri::HTML(open(url))
      h[k] = doc.css('exchangerate').inject({}) do |hsh, element|
        if element.css('exchangerate').count == 0
          unit = element.attr('unit') ? element.attr('unit').to_f * 10_000 : 1 # I don't know why 10_000
          buy = element.attr('buy').to_f / unit
          sell = element.attr('sale').to_f / unit
          sell = nil if sell == 0
          hsh[element.attr('ccy').downcase.to_sym] = [buy, sell].compact
        end
        hsh
      end
      h
    end
  end

  def office_search
    @office_search = OfficeSearch.new(office_search_params[:office_search])

    respond_to do |format|
      format.html { render 'pages/office_search' }
      format.json do
        render json: @office_search.search
      end
    end
  end

  def bonus_plus_search
    @bonus_plus_search = BonusPlusSearch.new(bonus_plus_search_params[:bonus_plus_search])

    respond_to do |format|
      format.html { render 'pages/bonus_plus_search' }
      format.json do
        render json: @bonus_plus_search.search
      end
    end
  end

  protected
  def bonus_plus_search_params
    params.permit(bonus_plus_search: [:city, :state, :street, :type])
  end

  def office_search_params
    params.permit(office_search: [:city, :street])
  end
end
