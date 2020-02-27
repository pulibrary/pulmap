# frozen_string_literal: true

require 'rails_helper'

describe 'search fields', type: :request do
  describe 'title search' do
    it 'matches search against title index' do
      get '/catalog.json?search_field=title&q=10+meter+countours'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 1
    end
    it 'does not include subject index' do
      get '/catalog.json?search_field=title&q=elevation'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 0
    end
  end
  describe 'publisher search' do
    it 'matches search against publisher index, terms tokenized as text' do
      get '/catalog.json?search_field=publisher&q=British+Survey'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 1
    end
    it 'includes creator index' do
      get '/catalog.json?search_field=publisher&q=Circuit+Rider+Productions'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 1
    end
  end
  describe 'subject search' do
    it 'matches search against index' do
      get '/catalog.json?search_field=subject&q=elevation'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 2
    end
    it 'includes spatial field' do
      get '/catalog.json?search_field=subject&q=Russia+Saint+Petersburg'
      r = JSON.parse(response.body)
      expect(r['data'].length).to eq 1
    end
  end
end
