module Importer
  module Factory
    class ItemFactory < ObjectFactory
      include WithAssociatedCollection

      self.klass = Item

    end
  end
end
