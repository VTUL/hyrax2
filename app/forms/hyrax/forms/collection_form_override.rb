module Hyrax
  module Forms
    module CollectionFormOverride

      def self.prepended(base)
        base.terms += [:rights, :date, :source, :bibliographic_citation,
                     :rights_holder, :coverage]

        base.required_fields += [:rights, :identifier, :rights_holder]
      end

      # Terms that appear above the accordion
      def primary_terms
        [:title, :description, :creator, :source, :date_created, :date, :rights,
         :language, :identifier, :bibliographic_citation, :rights_holder,
         :coverage, :subject]
      end

      # Terms that appear within the accordion
      def secondary_terms
        []
      end
    end
  end
end
