require 'rails_helper'

describe 'geoserver proxy' do
  it 'proxy requires authentication' do
    visit '/geoserver/restricted/wms'
    expect(current_path).to eq user_session_path
  end
end
