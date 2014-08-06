module Structs
  class Recipe < Struct.new(:title, :image_link, :recipe_link, :ingredients)
  end
end