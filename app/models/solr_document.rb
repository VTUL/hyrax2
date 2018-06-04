# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models. 

  use_extension( Hydra::ContentNegotiation )

  def rights
    first(Solrizer.solr_name('rights'))
  end

  def coverage
    self[Solrizer.solr_name('coverage')]
  end

  def date
    first(Solrizer.solr_name('date'))
  end

  def date_created
    first(Solrizer.solr_name('date_created'))
  end

  def date_range
    if date.blank?
      date_range = date_created
    else
      date_range = date_created + ' - ' + date
    end
  end

  def medium
    self[Solrizer.solr_name('medium')]
  end

  def bibliographic_citation
    first(Solrizer.solr_name('bibliographic_citation'))
  end

  def rights_holder
    first(Solrizer.solr_name('rights_holder'))
  end

  def location
    self[Solrizer.solr_name('location')]
  end

  def format
    self[Solrizer.solr_name('format')]
  end

  def contributor 
    self[Solrizer.solr_name('contributor')]
  end
end
