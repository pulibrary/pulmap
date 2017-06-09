require 'rails_helper'

feature 'advanced search' do
  feature 'edit search' do
    scenario 'simple keyword term is carried over' do
      visit '/?search_field=all_fields&q=map'
      click_link 'Edit search'
      expect(page).to have_css "#q1[value='map']", count: 1
    end
    scenario 'advanced keyword terms, fields, and operations carried over' do
      visit '/?f1=all_fields&q1=maps&op2=NOT&f2=title&q2=princeton&op3=NOT'\
            '&f3=publisher&q3=prussia&search_field=advanced'
      click_link 'Edit search'
      expect(page).to have_css "#q1[value='maps']", count: 1
      expect(page).to have_css "#q2[value='princeton']", count: 1
      expect(page).to have_css "#q3[value='prussia']", count: 1
      expect(page).to have_css "#f2 > option[value='title'][selected='selected']", count: 1
      expect(page).to have_css "#f3 > option[value='publisher'][selected='selected']", count: 1
      expect(page).to have_css "#op2_NOT[checked='checked']", count: 1
      expect(page).to have_css "#op3_NOT[checked='checked']", count: 1
    end
    scenario 'advanced facets are carried over' do
      visit '/?f_inclusive%5Bdc_format_s%5D%5B%5D=GeoTIFF&f_inclusive'\
            '%5Bdc_format_s%5D%5B%5D=Paper&search_field=advanced'
      click_link 'Edit search'
      expect(page).to have_css "option[value='GeoTIFF'][selected='selected']", count: 1
      expect(page).to have_css "option[value='Paper'][selected='selected']", count: 1
    end
  end
end
