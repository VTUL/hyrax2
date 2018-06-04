# Generated via
#  `rails generate hyrax:work Item`
module Hyrax
  # Generated form for Item
  class ItemForm < Hyrax::Forms::WorkForm
    self.model_class = ::Item
    self.terms += [:resource_type, :date, :rights, :coverage, :location,
                   :medium, :bibliographic_citation, :rights_holder,
                   :format, :related_url, :contributor]
    self.terms -= [:license, :rights_statement]
    self.required_fields = [:title, :rights, :identifier, :rights_holder]

    def primary_terms
      [:title, :description, :keyword, :creator, :source, :date_created, :date,
      :rights, :language, :resource_type, :identifier, :coverage, :location,
      :medium, :bibliographic_citation, :rights_holder, :format, :related_url,
      :contributor]
    end

    def secondary_terms
      []
    end
  end
end
