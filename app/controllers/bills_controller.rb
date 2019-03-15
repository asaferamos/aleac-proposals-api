require 'mechanize'

class BillsController < ApplicationController
    def new
        ext_id = params[:ext_id]
    end

    def getFile(url)

        if /^spec/.match(Rails.configuration.url_aleac)
            url_base = Rails.configuration.url_aleac
            url = url.gsub!(/\//m,'__')
            return Nokogiri::HTML(
                open("#{url_base}#{url}")
            )

        else
            url_base = Rails.configuration.url_aleac
            agent = Mechanize.new
            return agent.get(
                "#{url_base}#{url}"
            )
        end
    end
end
