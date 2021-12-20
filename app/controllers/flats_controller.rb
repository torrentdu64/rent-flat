class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_flat, only: [:show, :create_plan]

  def index
    @flats = Flat.all
  end

  def show

  end

  def new
    @flat = Flat.new
    @price = Price.new
  end

  def dashboards
    @flats = current_user.flats.all

    @flat = Flat.new
    @price = Price.new
  end

  def create
    #@price = Price.new(price_params)
    @flat = current_user.flats.build(flat_params)
    #@price.save &&
    if  @flat.save
      flash[:notice] = "Flat register"
      redirect_to dashboards_path(@flat)
    else
      flash[:notice] = "Flat fail"
      render :new
    end
  end

  def create_plan
     @flat = Flat.new(flat_params)

      redirect_to :show
  end

  def edit
  end

  def update
  end

  def destroy
  end

   def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to flats_path
  end

  def remove_from_cart
    id = params[:id].to_i
    session[:cart].delete(id)
    redirect_to flats_path
  end

 private

  def set_flat
    @flat = Flat.find(params[:id])
  end

  def flat_params
    params.require(:flat).permit(:title, :price )
  end

  def price_params
    params.require(:flat).permit(:currency, :nickname, :recurring)
  end

end

