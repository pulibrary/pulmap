# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Geoblacklight::SolrDocument
  include GeomonitorConcern
  include SanbornConcern
  include WmsRewriteConcern

  # self.unique_key = 'id'
  self.unique_key = "layer_slug_s"

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant DC document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Override to disable iiif downloads for Princeton scanned maps because the user
  # can download the images using the Universal Viewer.
  def iiif_download
    return super unless same_institution?
    false
  end

  # Tests if record has a thumbnail reference for display on show page.
  def thumbnail_reference?
    return true if fetch(references.reference_field, {})["http://schema.org/thumbnailUrl"]
    false
  end

  def sidecar
    # Find or create, and set version
    sidecar = SolrDocumentSidecar.where(
      document_id: id,
      document_type: self.class.to_s
    ).first_or_create do |sc|
      sc.version = _source["_version_"]
    end

    sidecar
  end
end
