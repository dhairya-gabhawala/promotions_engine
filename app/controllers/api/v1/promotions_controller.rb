class Api::V1::PromotionsController < Api::ApplicationController

    def index
        current_date = Date.strptime(params[:current_date], "%m/%d/%Y")
        promotions = @property.promotions.where(status: :active, start: [nil, ...current_date], end: [nil, current_date...]).order(rank: :asc)
        @promotions = []
        if promotions
        	promotions.each do |p|

                if !params[:skus] && p.included_products.any?
                    next
                end

                if params[:skus]
                    skus = params[:skus].split(",").map{|s| "'#{s}'"}

                    if p.excluded_products.any?
                        next if p.excludes_products?(skus.join(",")).length === skus.length
                    end

                    if p.included_products.any?
                        next if p.includes_products?(skus.join(",")).empty?
                    end
                end

        		if p.condition
        			rulio = p.condition.to_rulio(params)
        			if rulio.execute
        				@promotions.push(p)
        			else
        				next
        			end
        		else
        			@promotions.push(p)
        		end
        	end
        end

        respond_to do |format|
            format.json
        end
    end

    def status
        render json: {status: :authenticated, message: "All good"}
    end

end
