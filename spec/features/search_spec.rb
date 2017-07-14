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

  scenario 'When searching child records from a parent record, supressed records are not hidden' do
    visit '/?f[dct_source_sm][]=princeton-1r66j405w&q='
    expect(page).to have_css '.document', count: 4
  end

  feature 'spatial search' do
    scenario 'When searching using a bbox constraint, hide the coordinates' do
      visit '/catalog?bbox=-74.97447967529297%2040.237605%20-74.28783416748047%2040.446947'
      expect(page).to have_css 'span.appliedFilter.constraint', count: 1
      expect(page).to have_content 'Bounding Box'
      expect(page).not_to have_content '-74.97447967529297 40.237605 -74.28783416748047 40.446947'
    end
  end
end
