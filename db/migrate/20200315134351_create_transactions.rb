class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :uuid, null: false, comment: 'Merchant ID'
      t.string :customer_email, comment: 'Customer Email'
      t.string :customer_phone, null: false, comment: 'Customer Phone'
      t.decimal :amount, comment: 'Transaction amount'
      t.string :type, comment: 'Transaction type, used for STI'
      t.integer :status, default: 0, null: false, comment: 'Status of transaction'
      t.timestamps
    end
  end
end
