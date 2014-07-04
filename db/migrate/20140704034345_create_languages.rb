class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.references :user, index: true
      t.string :name, null: false, default: ""
    end
  end
end
