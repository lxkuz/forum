class LoadMerchants < QueryService
  def call
    User.merchants.order(name: :asc).page(params[:page])
  end
end
