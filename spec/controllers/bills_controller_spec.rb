require 'rails_helper'

RSpec.describe BillsController, type: :request do
    it "test if all fields are in response" do
        
        get "/proposal/4059"

        expect(response).to match_json_schema("proposal")

    end

    it "test some fields of proposal" do

        get "/proposal/4059"

        json_response = JSON.parse(response.body)
        
        expect(json_response['ext_id']).to eq("4059")
        expect(json_response['author']).to eq("Governo - Governador")
        expect(json_response['kind']).to eq("Projeto de Lei")
        expect(json_response['year']).to eq("2013")
        expect(json_response['link']).to eq("https://sapl.al.ac.leg.br/media/sapl/public/materialegislativa/2013/4059/4059_texto_integral.pdf")

    end
end
