class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, merchant: 1 }

  validates :role, :total_transaction_sum, presence: true

  scope :merchants, -> { where role: :merchant }
  scope :admins, -> { where role: :admin }

  protected

  def password_required?
    return false if merchant?

    super
  end
end
