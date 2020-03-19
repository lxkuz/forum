class Transaction < ApplicationRecord
  belongs_to :merchant, class_name: :User, foreign_key: :uuid

  validates :customer_phone, presence: true
  validate :check_positive_amount, :check_active_merchant 

  private

  def check_positive_amount
    return if amount.nil?

    if amount.negative?
      errors.add(:amount, "can't be negative")
    elsif amount.zero?
      errors.add(:amount, "can't be zero")
    end
  end

  def check_active_merchant
    errors.add(:merchant, "inactive merchant") unless merchant.active?
  end
end
