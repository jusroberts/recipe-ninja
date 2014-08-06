module Ingredient
  module Parser
    class AllRecipes < Generic

      protected

      def custom_before_parsing(ingredient_string)
        ingredient_string.gsub!("\n", '')
        ingredient_string.gsub!("\r", '')
        ingredient_string.split.join(" ")
      end
    end
  end
end
