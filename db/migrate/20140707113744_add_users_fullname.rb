class AddUsersFullname < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :full_name, default: ""
    end
  end
end
