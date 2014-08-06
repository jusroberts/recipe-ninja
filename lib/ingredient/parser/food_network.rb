module Ingredient
  module Parser
    class FoodNetwork < Generic

      protected

      def custom_after_parsing(ingredient_struct)
        ingredient = ingredient_struct
        ingredient.ingredient = ingredient.ingredient.split(',')[0]
        ingredient
      end
    end
  end
end
