class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :integer,
               null: false,
               comment: 'User role (admin or merchant)'
    add_column :users, :name, :string, comment: 'Company name'
    add_column :users, :total_transaction_sum, :decimal,
               null: false,
               default: 0.0,
               comment: 'Total income amount'
  end
end
