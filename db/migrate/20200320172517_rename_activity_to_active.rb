class RenameActivityToActive < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :activity, :active
  end
end
