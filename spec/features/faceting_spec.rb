require 'rails_helper'

RSpec.feature 'Faceting', type: :feature do
  scenario 'Faceting on a field that allow multiple values, user can remove that facet value' do
    visit '/?f[dc_subject_sm][]=Statistics&q=Uganda'
    expect(first('a.remove')[:href]).to eq('/?q=Uganda')
  end

  scenario 'Faceting on a field that allows only single values, user can remove all facets values' do
    visit '/?f[layer_geom_type_s][]=Polygon&q=Uganda'
    expect(page).to have_content 'All data types'
    expect(first('a.remove')[:href]).to eq('/?q=Uganda')
  end
end
