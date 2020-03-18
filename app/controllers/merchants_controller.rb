class MerchantsController < ApplicationController
  def index
    @merchants = LoadMerchants.call(list_params)
  end

  def edit
    @merchant = LoadMerchant.call(item_params)
    @transactions = LoadTransactions.call(item_params)
  end

  def update
    @merchant = LoadMerchant.call(params[:id])
    if @merchant.update resource_params
      redirect_to action: :index
    else
      render :edit
    end
  end

  private

  def list_params
    params.permit(:page)
  end

  def item_params
    params.permit(:id)
  end

  def resource_params
    params.require(:user).permit(:email, :name, :id, :activity)
  end
end
