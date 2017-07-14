require 'rails_helper'

describe 'catalog/_show_sanborn_legend.html.erb', type: :view do
  context 'when the resource is a Sanborn map' do
    let(:document) { instance_double('document', published_by_sanborn?: true) }
    it 'renders a collapsed panel' do
      render
      expect(rendered).to have_css '.show-sanborn-legend .panel-heading.collapse-toggle.collapsed'\
                                   '[data-target="#sanborn-legend-panel-body"]'
      expect(rendered).to have_css '#sanborn-legend-panel-body'
    end
  end
end
