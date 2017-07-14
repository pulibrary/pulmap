require 'rails_helper'

describe 'catalog/_constraints_element.html.erb', type: :view do
  context 'when no value is supplied' do
    before do
      render partial: 'catalog/constraints_element', locals: { label: 'my label', value: nil }
    end

    it 'does not render blank values' do
      expect(rendered).not_to have_content 'my value'
      expect(rendered).to have_css '.filterBlank'
    end
  end
  context 'when a value is supplied' do
    before do
      render partial: 'catalog/constraints_element',\
             locals: { label: 'my label', value: 'my value' }
    end

    it 'renders values' do
      expect(rendered).to have_content 'my value'
      expect(rendered).not_to have_css '.filterBlank'
    end
  end
end
