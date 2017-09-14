require 'rails_helper'

feature 'geoserver proxy' do
  scenario 'proxy requires authentication' do
    visit '/geoserver/restricted/wms'
    expect(current_path).to eq user_session_path
  end
end
