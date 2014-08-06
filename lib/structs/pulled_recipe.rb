module Structs
  class PulledRecipe < Struct.new(:title, :image_link, :recipe_link, :ingredients)
  end
end