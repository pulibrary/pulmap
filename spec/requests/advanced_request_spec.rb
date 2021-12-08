# frozen_string_literal: true

require 'rails_helper'

describe 'advanced search', type: :request do
  it 'search across when multiple fields' do
    get '/catalog.json?f1=subject&q1=&op2=AND&f2=title&q2=foot&op3=AND&f3=publisher'\
        '&q3=cambridge&search_field=advanced'
    r = JSON.parse(response.body)
    expect(r['data'].length).to eq 1
  end
  it 'supports advanced render constraints' do
    get '/catalog?search_field=advanced&f1=title&q1=for1&op2=AND&f2=' \
        'title&q2=s&op3=AND&f3=title&q3=searching+for'
    expect(response.body.include?('<a class="btn btn-default btn-constraint remove" aria-label="remove constraint" href="/catalog?action=index&amp;controller=catalog&amp;f2=title&amp;'\
                                  'f3=title&amp;op2=AND&amp;op3=AND&amp;q2=s&amp;q3=searching+for&amp;search_field=advanced"><span class="remove-icon"></span>'\
                                  '<span class="d-none">Remove constraint Title: for1</span></a>')).to eq true
  end
  it 'does not error when only the 3rd query field has a value' do
    get '/catalog?f1=subject&q1=&op2=AND&f2=publisher&q2=&op3=AND&f3=title&q3='\
        'anything&search_field=advanced&commit=Search'
    expect(response.status).to eq(200)
  end
  it 'successful search when the 1st and 3rd query are same field, 2nd query field different' do
    get '/catalog?f1=subject&q1=something&op2=AND&f2=publisher&q2=&op3=OR&f3=subject&q3='\
        'anything&search_field=advanced&commit=Search'
    expect(response.status).to eq(200)
  end
end
