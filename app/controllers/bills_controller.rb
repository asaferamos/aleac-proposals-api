require 'mechanize'
require 'date'

class BillsController < ApplicationController
    def new
        ext_id = params[:ext_id]

        # get properties of index proposal
        proposalPageIndex = getFile("/materia/#{ext_id}")

        kind = proposalPageIndex.search(
            'div#div_id_tipo div.form-control-static'
        ).text

        year = proposalPageIndex.search(
            'div#div_id_ano div.form-control-static'
        ).text

        number = proposalPageIndex.search(
            'div#div_id_numero div.form-control-static'
        ).text

        introduction_date = proposalPageIndex.search(
            'div#div_id_data_apresentacao div.form-control-static'
        ).text

        description = proposalPageIndex.search(
            'div#div_id_ementa div.form-control-static'
        ).text

        link = proposalPageIndex.search(
            'div#div_id_texto_original div.form-control-static a'
        )[0].attr('href')

        # get authors of proposal
        proposalPageAuthors = getFile("/materia/#{ext_id}/autoria")

        authors = []
        proposalPageAuthors.search('table tr').each do |tr|
            author = tr.search('td').search('a').text
            if author != ""
                authors.push(author)
            end
        end
        authors.delete("a")

        json_response = {
            'ext_id'      => ext_id,
            'authors'     => authors,
            'king'        => kind,
            'number'      => number,
            'year'        => year,
            'description' => description.gsub!(/\r/,' '),
            'link'        => Rails.configuration.url_aleac + link,
            'introduction_date' => Date.parse(introduction_date)
        }

        render json: json_response
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
