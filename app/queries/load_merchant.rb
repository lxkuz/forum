class LoadMerchant < QueryService
  def call
    User.find(params[:id])
  end
end
