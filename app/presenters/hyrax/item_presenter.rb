# Generated via
#  `rails generate hyrax:work Item`
module Hyrax
  class ItemPresenter < Hyrax::WorkShowPresenter
    delegate :date, :coverage, :location, :medium, :bibliographic_citation,
             :rights, :rights_holder, :format, :contributor, to: :solr_document

    def attribute_to_html(field, options = {})
      unless respond_to?(field)
        Rails.logger.warn("#{self.class} attempted to render #{field}, but no method exists with that name.")
        return
      end
      if :date == field.to_sym
        value = send(:date_created)
        value += " - #{send(field)}" unless send(field).nil?
        renderer_for(field, options).new(field, value, options).render
      else
        renderer_for(field, options).new(field, send(field), options).render
      end
    end
  end
end
