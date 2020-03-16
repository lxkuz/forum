class MerchantsController < ApplicationController
  def index
    @merchants = User.where(role: :merchant).page params[:page]
  end

  def edit
    @merchant = User.find params[:id]
  end

  def update
    @merchant = User.find params[:id]
    if @merchant.update resource_params
      redirect_to action: :index
    else
      render :edit
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email, :name, :id)
  end
end
