# frozen_string_literal: true

require 'rails_helper'

describe 'catalog/_show_sanborn_legend.html.erb',type: :view do
  context 'when the resource is a Sanborn map' do
    let(:document) { instance_double('document', published_by_sanborn?: true) }

    it 'renders a collapsed card' do
      render
      expect(rendered).to have_css '.show-sanborn-legend '\
                                   '[data-target="#sanborn-legend-card-body"]'
      expect(rendered).to have_css '#sanborn-legend-card-body'
    end
  end
end
