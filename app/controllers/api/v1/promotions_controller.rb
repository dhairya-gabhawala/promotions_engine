class Api::V1::PromotionsController < Api::ApplicationController

    # If no parameters provided, all promotions will be returned.
    def index
        current_date = Date.strptime(params[:current_date], "%m/%d/%Y")
        promotions = @property.promotions.where(status: :active, start: [nil, ...current_date], end: [nil, current_date...]).order(rank: :asc)
        @promotions = []
        if promotions
            promotions.each do |p|
                if p.products.any?
                    if(params[:skus].nil?)
																								next
																				elsif (p.included_products.any? && p.includes_products?(params[:skus]).empty?) || (p.excluded_products.any? && !p.excludes_products?(params[:skus]).empty?)
                        next
                    end
                end
                if p.condition
                    rulio = p.condition.to_rulio(params)
                    if rulio.execute
                        @promotions.push(p)
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
