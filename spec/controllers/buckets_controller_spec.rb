require 'spec_helper'

describe BucketsController do
  before do
    sign_in @hunter = create(:hunter)
  end

  describe 'get action' do
    it 'should render json' do
      get(:get, format: :json)
      expect(response.content_type).to eq('application/json')
    end

    it 'should redirect to hunting_path' do
      get(:get, format: :html)
      expect(response.redirect_url).to eq(hunting_url)
    end

  end
end