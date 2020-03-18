class LoadTransactions < QueryService
  def call
    Transaction.where(uuid: params[:id])
  end
end
