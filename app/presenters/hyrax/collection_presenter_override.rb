module Hyrax
  module CollectionPresenterOverride

    def self.prepended(base)
      base.delegate :source, :date, :rights, :bibliographic_citation, :rights_holder, :coverage,
                to: :solr_document
      base.singleton_class.prepend ClassMethods
    end
    
    # Class methods
    module ClassMethods
      # Terms is the list of fields displayed by
      # app/views/collections/_show_descriptions.html.erb
      def terms
        [:total_items, :size, :resource_type, :creator, :source, :contributor, :keyword, 
         :license, :rights, :publisher, :date_created, :subject, :language, :identifier, 
         :bibliographic_citation, :rights_holder, :coverage, :based_near, :related_url]
      end
    end
  end
end
