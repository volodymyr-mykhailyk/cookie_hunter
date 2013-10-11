require 'spec_helper'

feature 'Hunting' do
  background do
    @hunter = login_hunter
    visit hunting_path
  end


  describe 'Click to add cookie' do
    before do
      click_on 'add_cookie_link'
    end

    it 'should add cookie' do
      expect(@hunter.reload.cookies).to eq(1)
    end

    it 'should redirect to correct path' do
      expect(current_path).to eq(hunting_path)
    end



  end


end