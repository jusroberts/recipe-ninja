class ShoppingList < ActiveRecord::Base
  has_many :recipes
  accepts_nested_attributes_for :recipes, allow_destroy: true
end
