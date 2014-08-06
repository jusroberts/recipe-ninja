module Utils
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
          :fluid_ounce,
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
          fluid_ounce: 6,
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
end