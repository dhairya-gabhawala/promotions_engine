class PropertiesController < ApplicationController

    before_action :authenticate_user!
    before_action :set_property, except: [:new, :create]

    def index
    end
    
    def show
     session[:property_id] = @property.id
    end

    def new
        @property = Property.new
    end

    def create
        @property = Property.new(property_params)
        if @property.save
            redirect_to property_path(@property), notice: "Property was successfully created."
        else
            render :new, status: :unprocessable_entity, alert: "There were some errors creating the property."
        end
    end

    def edit
    end

    def update
        if @property.update(property_params)
            redirect_to property_path(@property), notice: "Property was successfully updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @property.destroy
        redirect_to root_path, notice: "Property was successfully destroyed."
    end

    private

    def set_property
        if params[:id] || session[:property_id]
            @property = Property.find(params[:id] || session[:property_id])
        else
            redirect_to new_property_path
        end
    end
    
    def property_params
        params.require(:property).permit(:name)
    end
end
