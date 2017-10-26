require 'rails_helper'

describe ThumbnailHelper, type: :helper do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { dc_title_s: 'title', layer_geom_type_s: 'Polygon' } }

  describe '#gbl_thumbnail_img_tag' do
    context 'document has a thumbnail url' do
      before do
        allow(document).to receive(:thumbnail_url).and_return('http://www.example.com/image.jpg')
      end

      it 'returns a geoblacklight icon span and an image tag' do
        html = Capybara.string(helper.gbl_thumbnail_img_tag(document))
        expect(html).to have_xpath("//img[@data-aload='http://www.example.com/image.jpg']")
        expect(html).to have_xpath("//img[contains(@alt,'title')]")
        expect(html).to have_xpath("//span[contains(@class,'geoblacklight-polygon')]")
      end
    end

    context 'document does not have a thumbnail url' do
      before do
        allow(document).to receive(:thumbnail_url).and_return(nil)
      end

      it 'returns a only geoblacklight icon span' do
        html = Capybara.string(helper.gbl_thumbnail_img_tag(document))
        expect(html).to have_no_xpath('//img')
        expect(html).to have_xpath("//span[contains(@class,'geoblacklight-polygon')]")
      end
    end
  end
end
