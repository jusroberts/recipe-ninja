module Ingredient
  module Parser

    def self.create(url, ingredients)
      ingredient_parser = ingredient_parser_hash[parse_url(url)]
      return ingredient_parser.new(ingredients) unless ingredient_parser.nil?
      return Ingredient::Parser::Generic.new(ingredients)
    end

    private

    def self.parse_url(url)
      URI(url).host.downcase
    end

    def self.ingredient_parser_hash
      {
        'www.foodnetwork.com' => Ingredient::Parser::FoodNetwork,
        'foodnetwork.com' => Ingredient::Parser::FoodNetwork,
        'www.allrecipes.com' => Ingredient::Parser::AllRecipes,
        'allrecipes.com' => Ingredient::Parser::AllRecipes
      }
    end
  end
end