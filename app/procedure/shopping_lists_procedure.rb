require 'structs/pulled_recipe'
require 'ingredient/parser'
require 'ingredient/combiner'

class ShoppingListsProcedure
  attr_accessor :shopping_list, :ingredient_list, :recipes
  def initialize(shopping_list)
    @shopping_list = shopping_list
    @recipes = retrieve_recipes
    build_ingredient_list
  end

  def build_ingredient_list
    @ingredient_list = []
    parsed_ingredient_lists = get_ingredient_lists
    combined_ingredients = Ingredient::Combiner.new(parsed_ingredient_lists).combine_ingredients
    @ingredient_list = make_readable(combined_ingredients)
  end

  private

  def get_ingredient_lists
    @recipes.map do |recipe|
      Ingredient::Parser.create(recipe.recipe_link, recipe.ingredients).parse_ingredients
    end
  end

  def retrieve_recipes
    recipes = []
    @shopping_list.recipes.each do |recipe|
      next if recipe.url.blank?
      parsed_recipe = parse_recipe(recipe.url)
      next if parsed_recipe.nil?
      recipes << parsed_recipe
    end
    recipes
  end


  def parse_recipe recipe_url
    parsed_recipe, recipe_html = get_parsed_recipe recipe_url
    return if parsed_recipe.nil?
    Structs::PulledRecipe.new(
      parsed_recipe.name,
      get_picture_link(recipe_html, recipe_url),
      recipe_url,
      parsed_recipe.ingredients
    )
  end

  def get_parsed_recipe recipe_url
    recipe_html = open(recipe_url).read
    parsed_recipe = Hangry.parse(recipe_html)
    if parsed_recipe.ingredients.nil?
      recipe_url = known_recipe_uri_generator(recipe_url)
      return get_parsed_recipe(recipe_url) unless recipe_url.nil?
    end
    return parsed_recipe, recipe_html
  end

  def known_recipe_uri_generator (recipe_url)
    uri = URI(recipe_url)
    if uri.host == 'm.allrecipes.com'
      path = uri.path.split('/')
      url = "http://allrecipes.com"
      url += "/#{path[1]}/#{path[3]}"
      return url
    end
    return nil
  end

  def get_picture_link html, url
    Utils::ImageParser.new(url, html).get_link
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
