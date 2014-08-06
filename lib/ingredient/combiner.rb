module Ingredient
  class Combiner
    def initialize(ingredient_lists)
      @ingredient_lists = ingredient_lists
    end

    def combine_ingredients
      ingredients = []
      @ingredient_lists.each do |ingredients_list|
        ingredients_list.each do |ingredient|
          if ingredient.ingredient.blank?
            next
          end
          if ingredients_contains_ingredient(ingredients, ingredient)
            ingredients = add_ingredient_to_ingredients(ingredients, ingredient)
          else
            ingredients << ingredient
          end
        end
      end
      ingredients
    end

    def ingredients_contains_ingredient(ingredients, ingredient)
      return false if get_ingredient_position(ingredients, ingredient) == -1
      return true
    end

    def add_ingredient_to_ingredients(ingredients, ingredient)
      position = get_ingredient_position(ingredients, ingredient)
      ingredients[position] = add_ingredients(ingredients[position], ingredient)
      ingredients
    end

    def get_ingredient_position(ingredients, ingredient)
      ingredients.each_with_index do |ing, i|
        if ing.ingredient == ingredient.ingredient
          if Utils::UnitConverter.determine_unit_type(ing.unit) == Utils::UnitConverter.determine_unit_type(ingredient.unit)
            return i
          end
        end
      end
      return -1
    end

    def add_ingredients(ingredient1, ingredient2)
      if ingredient1.unit == ingredient2.unit
        ingredient1.amount += ingredient2.amount
      else
        amount, unit = add_uneven_units(ingredient1, ingredient2)
        ingredient1.amount = amount
        ingredient1.unit = unit
      end
      return ingredient1
    end

    def add_uneven_units(ingredient1, ingredient2)
      base_units1 = convert_to_base_units(ingredient1.amount, ingredient1.unit)
      base_units2 = convert_to_base_units(ingredient2.amount, ingredient2.unit)
      combined_base = base_units1 + base_units2
      return combined_base, base_unit(ingredient1.unit)
    end

    def convert_to_base_units(amount, unit)
      amount * Utils::UnitConverter.base_value(unit)
    end
  end
end