class MerchantsController < ApplicationController
  def index
    merchants = User.where(role: :merchant)
    render json: merchants
  end
end
