class AddCrmIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :crmuser_id, :string
  end
end
