require 'rails_helper'

describe 'catalog/_featured_content.html.erb', type: :view do
  before do
    render
  end
  it 'renders the default heading "Featured Content"' do
    expect(rendered).to have_css '.topics .er_toc_tag'
    expect(rendered).to have_content 'Featured Content'
  end
end
