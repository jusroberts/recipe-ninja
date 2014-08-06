module Structs
  class ParsedIngredient < Struct.new(:ingredient, :unit, :amount)
  end
end
