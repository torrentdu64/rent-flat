class PricesController < ApplicationController
  before_action :set_flat, only: [ :new , :create]

  def destroy
    @flat = Flat.find(params[:id])
    @price = @flat.pricing.find(params[:format])
    if @flat.stripe_price_id.present? && @price.stripe_price_id.include?(@flat.stripe_price_id)
      @flat.update(stripe_price_id: nil )
    end
    @price.destroy

    redirect_to dashboards_path
  end

  def new
    @price = Price.new
  end

  def create
    @flat = current_user.flats.find(params[:flat_id])
    @price = @flat.pricing.build(price_params)

    if @price.save
      flash[:notice] = "Flat register"
      redirect_to dashboards_path(@flat)
    else
      flash[:notice] = "Flat fail"
      render :new
    end
  end

  def edit
    @flat = current_user.flats.find(params[:flat_id])
    @price = @flat.pricing.find(params[:id])
  end

  def update
    byebug
    @flat = current_user.flats.find(params[:id])
    @price = @flat.pricing.find(params[:format])
    #byebug
    #@price.save &&
    if @price.update(price_params)
      flash[:notice] = "Flat updated"
      redirect_to dashboards_path(@flat)
    else
      flash[:notice] = "Flat fail"
      render :new
    end
  end


  private

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end

  def price_params
    params.require(:price).permit(:price, :currency, :nickname, :recurring)
  end

end
