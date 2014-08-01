class ShoppingListsProcedure
  attr_accessor :shopping_list, :ingredient_list
  def initialize(shopping_list)
    @shopping_list = shopping_list
    build_ingredient_list
  end

  def build_ingredient_list
    @ingredient_list = []
    unparsed_ingredient_lists = get_ingredient_lists
    parsed_ingredient_lists = parse_ingredients_lists(unparsed_ingredient_lists)
    combined_ingredients = combine_ingredients(parsed_ingredient_lists)
    @ingredient_list = make_readable(combined_ingredients)
  end

  private

  def get_ingredient_lists
    recipes = retrieve_recipes
    recipes.map do |recipe|
      recipe.ingredients
    end
  end

  def retrieve_recipes
    recipes = []
    @shopping_list.recipes.each do |recipe|
      next if recipe.url.blank?
      recipes << parse_recipe(recipe.url)
    end
    recipes
  end


  def parse_recipe recipe_url
    Hangry.parse(open(recipe_url).read)
  end

  def parse_ingredients_lists ingredients_lists
    ingredients_lists.map do |ingredients_list|
      parse_ingredients(ingredients_list)
    end
  end

  def parse_ingredients ingredients
    ingredients.map do |ingredient|
      ingredient.gsub!("\n", '')
      ingredient.gsub!("\r", '')
      i = ingredient.split.join(" ")
      Ingreedy.parse(i)
    end
  end

  def combine_ingredients(parsed_ingredient_lists)
    ingredients = []
    parsed_ingredient_lists.each do |ingredients_list|
      ingredients_list.each do |unconverted_ingredient|
        ingredient = convert_ingredient(unconverted_ingredient)

        if ingredients_contains_ingredient(ingredients, ingredient)
          ingredients = add_ingredient_to_ingredients(ingredients, ingredient)
        else
          ingredients << ingredient

        end
      end
    end
    ingredients
  end

  def convert_ingredient(unconverted_ingredient)
    ingredient = Ingredient.new
    ingredient.ingredient = unconverted_ingredient.ingredient
    ingredient.amount = unconverted_ingredient.amount
    ingredient.unit = unconverted_ingredient.unit
    ingredient
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
        if UnitConverter.determine_unit_type(ing.unit) == UnitConverter.determine_unit_type(ingredient.unit)
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
    amount * UnitConverter.base_value(unit)
  end

  def make_readable(ingredient_list)
    ingredient_list.map do |ingredient|
      "#{parse_amount ingredient.amount} #{pluralize(ingredient.amount, ingredient.unit)} #{ingredient.ingredient}"
    end
  end

  def parse_amount amount
    return '' if amount == 0
    "%g" % amount
  end

  def pluralize(number, unit)
    return "" if unit.nil?
    return "#{unit}" if number == 1
    return "#{unit}s"
  end
end

class UnitConverter
  class << self

    def determine_unit_type(unit)
      return 'imperial_volume' if imperial_volume_array.include? unit
      return 'imperial_weight' if imperial_weight_array.include? unit
      return 'metric_volume' if metric_volume_array.include? unit
      return 'metric_mass' if metric_mass_array.include? unit
      return 'unknown'
    end

    def base_unit(unit)
      unit_type = determine_unit_type(unit)
      method(:"#{unit_type}_array").call[0]
    end

    def base_value(unit)
      unit_type = determine_unit_type(unit)
      method(:"#{unit_type}_hash").call[unit]
    end

    def imperial_volume_array
      [
        :teaspoon,
        :tablespoon,
        :cup,
        :pint,
        :quart,
        :gallon
      ]
    end

    def imperial_weight_array
      [
        :ounce,
        :pound
      ]
    end

    def metric_volume_array
      [
        :milliliter,
        :liter
      ]
    end

    def metric_mass_array
      [
        :milligram,
        :gram,
        :kilogram
      ]
    end

    def imperial_volume_hash
      {
        teaspoon: 1,
        tablespoon: 3,
        cup: 48,
        pint: 96,
        quart: 192,
        gallon: 768
      }
    end

    def imperial_weight_hash
      {
        ounce: 1,
        pound: 16
      }
    end

    def metric_volume_hash
      {
        milliliter: 1,
        liter: 1000
      }
    end

    def metric_mass_hash
      {
        milligram: 1,
        gram: 1000,
        kilogram: 1000000
      }
    end
  end
end

class Ingredient < Struct.new(:ingredient, :unit, :amount)
end
