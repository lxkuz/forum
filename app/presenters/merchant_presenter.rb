class MerchantPresenter
  def initialize(merchant)
    @merchant = merchant
  end

  delegate :id, :email, :name, to: :merchant

  def active
    if merchant.active
      'Active'
    else
      'Inactive'
    end
  end

  private

  attr_reader :merchant
end
