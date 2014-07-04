class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.references :user, index: true
      t.string :name, null: false, default: ""
    end
  end
end
