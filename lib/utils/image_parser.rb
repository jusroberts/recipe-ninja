module Utils
  class ImageParser
    attr_accessor :link, :html

    def initialize(link, html)
      @link = link
      @html = html
    end

    def get_link
      host = parse_host
      if host == "allrecipes.com" || host == "www.allrecipes.com"
        parse_all_recipes
      elsif host == "foodnetwork.com" || host = "www.foodnetwork.com"
        parse_food_network
      else
        return "http://thumbs.dreamstime.com/z/chef-cook-baker-fruti-food-veges-17750784.jpg"
      end

    end

    private

    def parse_all_recipes
      get_doc.css("#imgPhoto").first[:src]
    end

    def parse_food_network
      doc = get_doc
      begin
        return doc.css("#video").css('img')[0][:src]
      rescue
        begin
          return doc.css('section.single-photo-recipe').first.css('img').first[:src]
        rescue
          return "http://thumbs.dreamstime.com/z/chef-cook-baker-fruti-food-veges-17750784.jpg"
        end
      end
    end

    def get_doc
      Nokogiri::HTML.parse(@html)
    end

    def parse_host
      URI(link).host
    end

  end
end
