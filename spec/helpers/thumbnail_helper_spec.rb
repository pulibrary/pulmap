require 'rails_helper'

describe ThumbnailHelper, type: :helper do
  include GeoblacklightHelper

  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_geom_type_s: 'Polygon' } }

  describe '#gbl_thumbnail_img' do
    context 'document has a thumbnail url' do
      it 'returns a geoblacklight icon span and an image tag' do
        allow(document).to receive('thumbnail_url').and_return('http://www.example.com/image.jpg')
        html = Capybara.string(gbl_thumbnail_img(document))
        expect(html).to have_xpath("//img[@data-aload='http://www.example.com/image.jpg']")
        expect(html).to have_xpath("//span[contains(@class,'geoblacklight-polygon')]")
      end
    end

    context 'document does not have a thumbnail url' do
      it 'returns a only geoblacklight icon span' do
        allow(document).to receive('thumbnail_url').and_return(nil)
        html = Capybara.string(gbl_thumbnail_img(document))
        expect(html).to have_no_xpath('//img')
        expect(html).to have_xpath("//span[contains(@class,'geoblacklight-polygon')]")
      end
    end
  end
end
