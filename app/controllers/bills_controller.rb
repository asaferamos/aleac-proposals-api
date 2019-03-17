require 'mechanize'
require 'date'

class BillsController < ApplicationController
    before_action :authorize_request
    require 'proposal'

    def index
        @current_user = getUserActive()

        proposals = Bill.where(user_id: @current_user.id)
        render json: proposals
    end

    def new
        @ext_id = params[:ext_id]

        Proposal.setId(@ext_id)

        render json: Proposal.getProposalJson
    end

    def create
        @current_user = getUserActive()

        Proposal.setId(params[:ext_id])
        jsonProposal = Proposal.getProposalJson

        puts jsonProposal['kind']

        proposal = Bill.new({
            ext_id:  params[:ext_id],
            user_id: @current_user.id,
            title:   "#{jsonProposal['kind']} nº #{jsonProposal['number']} de #{jsonProposal['year']}",
            status:  jsonProposal['status'],
            description: jsonProposal['description'].truncate(150)
        })

        # test if proposal already salved before
        if Bill.exists?({user_id: @current_user.id,ext_id: params[:ext_id]})
            render json: ['already saved']
        elsif proposal.save
            render json: proposal.id, status: 200
        else
            render json: proposal.errors, status: :unprocessable_entity
        end
    end

    def destroy
        begin
            proposal = Bill.where({user_id: @current_user.id,ext_id: params[:ext_id]}).take
            if proposal
                proposal.destroy
                render json: true
            else
                render json: false, status: 400
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: false
        end
    end

    def getUserActive()
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        decoded = JsonWebToken.decode(header)

        return User.find(decoded[:user_id])
    end
end