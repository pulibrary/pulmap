require 'rails_helper'

describe SanbornConcern do
  let(:document) { SolrDocument.new(document_attributes) }
  describe 'published_by_sanborn?' do
    context 'for resources published by Sanborn Map & Publishing Co.' do
      let(:document_attributes) do
        {
          dc_publisher_s: 'New York : Sanborn Map & Publishing Co., Limited, 1885.'
        }
      end
      it 'validates that this is a Sanborn Map surrogate' do
        expect(document.published_by_sanborn?).to be true
      end
    end

    context 'for resources published by other bodies' do
      let(:document_attributes) do
        {
          dc_publisher_s: 'U.S. Census Bureau'
        }
      end
      it 'confirms that this is a not Sanborn Map surrogate' do
        expect(document.published_by_sanborn?).to be false
      end
    end
  end
end
