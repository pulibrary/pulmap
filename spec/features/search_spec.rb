require 'rails_helper'

feature 'Search' do
  feature 'spelling suggestions' do
    scenario 'are turned on' do
      visit root_path
      fill_in 'q', with: 'prince'
      click_button 'search'
      expect(page).to have_content 'Did you mean to type:'
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
end
