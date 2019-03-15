require 'mechanize'
require 'date'

class BillsController < ApplicationController
    def new
        @ext_id = params[:ext_id]

        # get properties of index proposal
        proposalPageIndex = getFile("materia/#{@ext_id}")

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
        proposalPageAuthors = getFile("materia/#{@ext_id}/autoria")

        authors = []
        proposalPageAuthors.search('table tr').each do |tr|
            author = tr.search('td').search('a').text
            if author != ""
                authors.push(author)
            end
        end
        authors.delete("a")

        # get actions of proposal
        actions = getActions()

        json_response = {
            'ext_id'      => @ext_id,
            'authors'     => authors,
            'kind'        => kind,
            'number'      => number,
            'year'        => year,
            'status'      => @lastStatus,
            'description' => description.gsub!(/\r/,' '),
            'steps'       => actions,
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
                open("#{url_base}/#{url}")
            )

        else
            url_base = Rails.configuration.url_aleac
            agent = Mechanize.new
            return agent.get(
                "#{url_base}/#{url}"
            )
        end
    end

    def getActions
        actions = []
        @lastStatus = ""

        proposalPageActions = getFile("materia/#{@ext_id}/tramitacao")
        proposalPageActions.search('table tr').each.with_index do |tr,i_tr|
            action = []
            t = tr.search('td').each.with_index do |td,i_td|
                if i_td == 0
                    action[0] = Date.parse(td.text.gsub!("\n",'').strip)
                end

                if i_td == 1
                    action[1] = shortLocation(td.text.gsub!("\n",'').strip)
                end

                if i_td == 2
                    action[2] = "Enviado para #{shortLocation(td.text.gsub!("\n",'').strip)}:"
                end

                if i_td == 3
                    action[2] = "#{action[2]} #{td.text.gsub!("\n",'').strip}"
                    if i_tr == 1
                        @lastStatus = td.text.gsub!("\n",'').strip
                    end
                end
            end

            if i_tr != 0
                actions.push(action)
            end
        end

        return actions
    end

    def shortLocation(location)
        location = location.split(' - ')

        if location[0].length < location[1].length
            return location[0]
        else
            return location[1]
        end
    end
end
