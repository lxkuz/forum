class MerchantsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @merchants = LoadMerchants.call(params)
  end

  def edit
    @merchant = LoadMerchant.call(params)
    @transactions = LoadTransactions.call(params)
  end

  def update
    @merchant = LoadMerchant.call(params)
    if @merchant.update resource_params
      redirect_to action: :index
    else
      render :edit
    end
  end

  private

  def authenticate_admin!
    redirect_to user_session_path unless current_user.admin?
  end

  def resource_params
    params.require(:user).permit(:email, :name, :id, :activity)
  end
end
