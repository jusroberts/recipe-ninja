class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :url
      t.integer :shopping_list_id

      t.timestamps
    end
  end
end
