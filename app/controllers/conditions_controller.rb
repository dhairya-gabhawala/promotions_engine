class ConditionsController < ApplicationController

    before_action :set_promotion
    before_action :set_condition, only: [:edit, :update]

    def index
        @products = {
            included: @promotion.included_products,
            excluded: @promotion.excluded_products,
        }
    end

    def new
    end

    def create
        @condition= Condition.new(condition_params)
        @condition.promotion = @promotion
        if @condition.save!
            redirect_to property_promotion_conditions_path(@property, @promotion), notice: "Condition was successfully created."
        else
            render :index, status: :unprocessable_entity, alert: "There were some errors saving the conditions."
        end
    end

    def edit

    end

    def update
        if @condition.update(condition_params)
            redirect_to property_promotion_conditions_path(@property, @promotion), notice: "Condition was successfully updated."
        else
            render :index, status: :unprocessable_entity, alert: "There were some errors updating the conditions."
        end
    end

    def destroy
    end

    private

    def set_condition
        @condition = @promotion.condition
    end

    def set_promotion
        @promotion = @property.promotions.find(params[:promotion_id])
    end

    def condition_params
        params.require(:condition).permit(:promotion, :by,
                                            groups_attributes: [:id, :_destroy, :by,
                                                                operations_attributes: [:id, :_destroy, :variable_key, :operator, :constant]])
    end

end
