require 'spec_helper'

describe StockpilesController do
  before do
    sign_in @hunter = create(:hunter)
  end

  describe 'add action' do
    it 'should render json' do
      get(:add, format: :json)
      expect(response.content_type).to eq('application/json')
    end

    it 'should redirect to hunting_path' do
      get(:add, format: :html)
      expect(response.redirect_url).to eq(hunting_url)
    end

  end

  describe 'steal action' do
    it 'should render json' do
      get(:steal, format: :json, hunter_id: @hunter.id)
      expect(response.content_type).to eq('application/json')
    end

    it 'should redirect to hunting_path' do
      get(:steal, format: :html, hunter_id: @hunter.id)
      expect(response.redirect_url).to eq(hunting_url)
    end

  end
end