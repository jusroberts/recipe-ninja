class AddUserIdToShoppingList < ActiveRecord::Migration
  def change
    add_column :shopping_lists, :user_id, :integer
  end
end
