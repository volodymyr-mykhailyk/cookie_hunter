require 'spec_helper'

feature 'Bonuses' do
  background do
    #@hunter = login_hunter(create(:hunter, cookies: 4000))
    @hunter = login_hunter_remote(create(:hunter, cookies: 4000))
    visit hunting_path
  end

  describe 'buy Plus Click' do
    it 'should buy' do
      expect {
        click_on 'bonus_Bonuses::PlusClick'
      }.to change(@hunter.bonuses, :count).by(1)
    end

    describe 'Fail (not enough cookies)' do
      before { @hunter.stockpile.update_column(:cookies, 1)}
      it 'should not buy' do
        expect {
          click_on 'bonus_Bonuses::PlusClick'
        }.to change(@hunter.bonuses, :count).by(0)
      end
    end
  end

  describe 'Double request' do

    it 'should by only once' do
      expect {
        several_processes((1..3).to_a) do
          click_on 'bonus_Bonuses::PlusClick'
        end
      }.to change_model(@hunter.bonuses, :count).by(1)
    end

  end
end