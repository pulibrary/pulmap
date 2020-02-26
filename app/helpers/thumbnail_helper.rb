# frozen_string_literal: true

module ThumbnailHelper
  ##
  # Returns the GeoBlacklight thumbnail linked to the item record
  # @param document [SolrDocument]
  # @param opts [Hash]
  # @option opts [Int] :counter the index of the item in the result set.
  # @return [String]
  def gbl_thumbnail_img(document, opts = { counter: nil })
    img_tag = gbl_thumbnail_img_tag(document)
    link_to img_tag, url_for_document(document), document_link_params(document, opts)
  end

  ##
  # Returns html for displaying a geoblacklight thumbnail.
  # The thumbnail image is then loaded asynchronously via javascript.
  # @param [SolrDocument]
  # @return [String]
  def gbl_thumbnail_img_tag(document)
    url = "#{polymorphic_url(document)}/thumbnail"
    title = document['dc_title_s']
    content_tag(:img, nil,
                class: 'item-thumbnail',
                data: { aload: url.to_s },
                alt: title)
  end
end
