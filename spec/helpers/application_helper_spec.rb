require 'rails_helper'

describe ApplicationHelper, type: :helper do
  include Geoblacklight::ViewHelperOverride

  describe '#layout_type' do
    it 'returns index when on landing page' do
      allow(self).to receive(:params)
        .and_return(controller: 'catalog', action: 'index')
      allow(self).to receive(:has_search_parameters?).and_return(false)
      expect(layout_type).to eq 'index'
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
    it 'returns default when on search history page' do
      allow(self).to receive(:params).and_return(controller: 'search_history')
      expect(layout_type).to eq 'default'
    end
    it 'returns default when on bookmarks page' do
      allow(self).to receive(:params).and_return(controller: 'bookmarks')
      expect(layout_type).to eq 'default'
    end
    it 'returns default when on saved searches page' do
      allow(self).to receive(:params).and_return(controller: 'saved_searches')
      expect(layout_type).to eq 'default'
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
  describe '#default_layout?' do
    it 'returns true when on search_history page' do
      allow(self).to receive(:params).and_return(controller: 'search_history')
      expect(default_layout?).to be true
    end
    it 'returns true when on search history page' do
      allow(self).to receive(:params).and_return(controller: 'bookmarks')
      expect(default_layout?).to be true
    end
    it 'returns true when on saved searches page' do
      allow(self).to receive(:params).and_return(controller: 'bookmarks')
      expect(default_layout?).to be true
    end
  end
end
