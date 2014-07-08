class AddUsersFullname < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :fullname, default: ""
    end
  end
end
