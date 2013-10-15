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
      visit hunting_path
      click_on "steal_from_hunter_#{@hunter1.id}"
    end

    it 'should add cookie' do
      expect(@hunter1.reload.cookies).to eq(0)
    end

    it 'should remove cookie from steal_bucket' do
      expect(StealBucket.instance.cookies).to eq(1)
    end

    it 'should redirect to correct path' do
      expect(current_path).to eq(hunting_path)
    end
  end

  describe 'Click on steal_bucket' do
    before do
      StealBucket.instance.add
      click_on 'get_steal_bucket_link'
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

  describe 'buy bonus' do
    before do
      @hunter.stockpile.update_column(:cookies, 150)
      visit hunting_path
      click_on "available_bonus_ClickBonus"
    end

    it 'should check bonus' do
      expect(@hunter.active_bonuses.size).to eq(1)
    end

    it 'should check regeneration' do
      expect(@hunter.stockpile.reload.regeneration).to eq(1)
    end
  end



end