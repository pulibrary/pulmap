require 'rails_helper'

feature 'advanced search' do
  feature 'edit search' do
    scenario 'simple keyword term is carried over' do
      visit '/?search_field=all_fields&q=map'
      click_link 'Edit search'
      expect(page).to have_css "#q1[value='map']", count: 1
    end
  end

  feature 'date range' do
    scenario 'limits search results' do
      visit '/?q='
      fill_in 'range_solr_year_i_begin', with: '1778'
      fill_in 'range_solr_year_i_end', with: '1800'
      click_button 'Limit'
      expect(page).to have_content '1 entry found'
    end
  end

  scenario 'Suppressed records are hidden' do
    visit '/?q=Sanborn+Map+Company'
    expect(page).to have_css '.document', count: 1
  end

  scenario 'When searching child records from a parent record, supressed records are not hidden' do
    visit '/?f[dct_source_sm][]=princeton-1r66j405w&q='
    expect(page).to have_css '.document', count: 4
  end
end
