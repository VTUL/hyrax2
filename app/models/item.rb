# Generated via
#  `rails generate hyrax:work Item`
class Item < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = ItemIndexer
  validate :auto_fill_fields, on: :create
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your item must have a title.' }
  validates :rights, presence: { message: 'Your item must have a right.' }
  validates :identifier, presence: { message: 'Your item must have an identifier.' }
  validates :rights_holder, presence: { message: 'Your item must have a rights holder.' }

  property :medium, predicate: ::RDF::Vocab::DC.medium do |index|
    index.as :stored_searchable, :facetable
  end
  property :format, predicate: ::RDF::Vocab::DC11.format do |index|
    index.as :stored_searchable, :facetable
  end
  property :location, predicate: ::RDF::Vocab::DC.Location do |index|
    index.as :stored_searchable, :facetable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  private

    def auto_fill_fields
      rights = "Permission to publish material from the "
      rights += self.title.first || String.new
      rights += " must be obtained from University Libraries Special Collections, Virginia Tech."
      self.rights = rights
      self.rights_holder = "Special Collections, University Libraries, Virginia Tech"
      bibli_citation = "Researchers wishing to cite this collection should include the following information: - Special Collections, Virginia Polytechnic Institute and State University, Blacksburg, Va."
      self.bibliographic_citation = bibli_citation
    end
end
