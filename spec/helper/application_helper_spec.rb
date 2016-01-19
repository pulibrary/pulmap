require 'rails_helper'

describe ApplicationHelper, type: :helper do
  include Geoblacklight::ViewHelperOverride

  describe '#layout_type' do
    it 'returns home when on landing page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', action: 'index')
      allow(self).to receive(:has_search_parameters?).and_return(false)
      expect(layout_type).to eq 'home'
    end
    it 'returns index when on search results page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', q: 'roads', action: 'index')
      allow(self).to receive(:has_search_parameters?).and_return(true)
      expect(layout_type).to eq 'index'
    end
    it 'returns item when on show page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', action: 'show')
      expect(layout_type).to eq 'item'
    end
    it 'returns bookmarks when on search history page' do
      allow(self).to receive(:params).and_return(controller: 'search_history')
      expect(layout_type).to eq 'bookmarks'
    end
    it 'returns bookmarks when on bookmarks page' do
      allow(self).to receive(:params).and_return(controller: 'bookmarks')
      expect(layout_type).to eq 'bookmarks'
    end
  end
  describe '#home_layout?' do
    it 'returns true when on landing page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', action: 'index')
      allow(self).to receive(:has_search_parameters?).and_return(false)
      expect(home_layout?).to be true
    end
  end
  describe '#index_layout?' do
    it 'returns true when on search results page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', q: 'roads', action: 'index')
      allow(self).to receive(:has_search_parameters?).and_return(true)
      expect(index_layout?).to be true
    end
  end
  describe '#item_layout?' do
    it 'returns true when on show page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', action: 'show')
      expect(item_layout?).to be true
    end
    it 'returns false when on search history page' do
      allow(self).to receive(:params).and_return(controller: 'search_history')
      expect(item_layout?).to be false
    end
  end
  describe '#bookmarks_layout?' do
    it 'returns true when on search_history page' do
      allow(self).to receive(:params).and_return(controller: 'search_history')
      expect(bookmarks_layout?).to be true
    end
    it 'returns true when on search history page' do
      allow(self).to receive(:params).and_return(controller: 'bookmarks')
      expect(bookmarks_layout?).to be true
    end
  end
end
