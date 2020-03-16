class AddActivityToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users,
               :activity, :boolean,
               null: false, default: false,
               comment: 'Merchant active flag'
  end
end
