module Hyrax
  module Renderers
    class RightsAttributeRenderer < AttributeRenderer
      private

        def attribute_value_to_html(value)
          %(<span itempop="rights"><a href="/terms" target="_blank">#{value}</a></span>)
        end
    end
  end
end
