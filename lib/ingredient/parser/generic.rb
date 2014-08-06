module Ingredient
  module Parser
    class Generic

      def initialize(ingredients)
        @ingredients = ingredients
      end

      def parse_ingredients
        @ingredients.map do |ingredient|
          i = custom_before_parsing(ingredient)
          parsed_i = Ingreedy.parse(i)
          converted_ingredient = convert_ingredient(parsed_i)
          custom_after_parsing(converted_ingredient)
        end
      end

      protected

      def custom_before_parsing(ingredient_string)
        ingredient_string
      end

      def custom_after_parsing(ingredient_struct)
        ingredient_struct
      end

      private

      def convert_ingredient(unconverted_ingredient)
        ingredient = Structs::Ingredient.new
        ingredient.ingredient = unconverted_ingredient.ingredient
        ingredient.amount = unconverted_ingredient.amount
        ingredient.unit = unconverted_ingredient.unit
        ingredient
      end

    end
  end
end