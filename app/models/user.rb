class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum role: { admin: 0, merchant: 1 }

  validates :role, :total_transaction_sum, presence: true
  validate :check_total_transaction_sum_is_positive

  scope :merchants, -> { where role: :merchant }
  scope :admins, -> { where role: :admin }

  has_many :transactions, foreign_key: :uuid, dependent: :restrict_with_error

  protected

  def password_required?
    return false if merchant?

    super
  end

  def check_total_transaction_sum_is_positive
    errors.add(:total_transaction_sum, "can't be negative") if total_transaction_sum.negative?
  end
end
