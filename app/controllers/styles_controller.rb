class StylesController < ApplicationController
	before_action :set_style, only: [:show, :edit, :update, :destroy]
  	before_action :ensure_that_signed_in, except: [:index, :show]

  	def index
  		@styles = Style.all
  	end

  	def show
  	end

  	def new
  		@style = Style.new
  	end

  	def edit
  	end

  	def create
  		@style = Style.new params.require(:style).permit(:name, :description)
		if @style.save
        	redirect_to styles_path(@style)
      	else
        	render :new
      	end
  end

  def update
  	if @style.update(style_params)
    	redirect_to @style
    else 
    	render :edit
    end
  end

  def destroy
  	@style.destroy
  	redirect_to styles_path
  end


  private

    def set_style
      @style = Style.find(params[:id])
    end

    def style_params
      params.require(:style).permit(:name, :description)
    end


end