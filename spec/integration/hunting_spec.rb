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

  describe 'Steal cookie from another user' do
    before do
      @hunter1 = create(:hunter, cookies: 1)
      click_on 'get_bucket_link'
    end

    it 'should add cookie' do
      expect(@hunter.reload.cookies).to eq(1)
    end

    it 'should remove cookie from steal_bucket' do
      expect(StealBucket.instance.cookies).to eq(0)
    end

    it 'should redirect to correct path' do
      expect(current_path).to eq(hunting_path)
    end
  end

  describe 'Click on steal_bucket' do
    before do
      StealBucket.instance.add
      click_on 'get_bucket_link'
    end

    it 'should add cookie' do
      expect(@hunter.reload.cookies).to eq(1)
    end

    it 'should remove cookie from steal_bucket' do
      expect(StealBucket.instance.cookies).to eq(0)
    end

    it 'should redirect to correct path' do
      expect(current_path).to eq(hunting_path)
    end
  end


end