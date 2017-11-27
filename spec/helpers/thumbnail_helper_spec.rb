require 'rails_helper'

describe ThumbnailHelper, type: :helper do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_slug_s: "mit-us-ma-e25zcta5dct-2000", dc_title_s: 'title' } }
  let(:thumbnail_url) { "http://test.host/catalog/mit-us-ma-e25zcta5dct-2000/thumbnail" }

  describe '#gbl_thumbnail_img_tag' do
    context 'when document has a thumbnail url' do
      it 'returns a geoblacklight icon span and an image tag' do
        html = Capybara.string(helper.gbl_thumbnail_img_tag(document))
        expect(html).to have_xpath("//img[@data-aload='#{thumbnail_url}']")
        expect(html).to have_xpath("//img[contains(@alt,'title')]")
      end
    end
  end
end
