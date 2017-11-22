require 'rails_helper'

describe 'geoserver proxy' do
  it 'proxy requires authentication' do
    visit '/geoserver/restricted/wms'
    expect(page).to have_current_path(user_session_path)
  end
end
