module ShoppingListsHelper
  def parsed_recipe recipe_url
    Hangry.parse(open(recipe_url).read)
  end

  def parse_ingredients ingredients
    ingredients.map do |ingredient|
      ingredient.gsub!("\n", '')
      ingredient.gsub!("\r", '')
      i = ingredient.split.join(" ")
      Ingreedy.parse(i)
    end
  end
end
