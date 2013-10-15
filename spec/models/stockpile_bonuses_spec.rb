require 'spec_helper'

describe Stockpile do
  before do
    @stockpile = create(:stockpile, cookies: 5)
  end

  describe 'bonuses' do

    describe 'bonus price' do
      before do
        3.times { create(:grand_mother, stockpile: @stockpile) }
      end

      it 'should get count of grand_mother bonuses' do
        expect(@stockpile.bonus_count(Bonuses::GrandMother)).to eq(3)
      end

      it 'should check price' do
        price = Bonuses::GrandMother.new.price_for(@stockpile)
        expect(price).to eq(Bonuses::GrandMother::BASIC_PRICE * 4)
      end
    end

    describe 'buy bonus' do
      before do
        @stockpile.update_column(:cookies, 350)
        @result = @stockpile.buy_bonus(Bonuses::GrandMother)
        @stockpile.instance_variable_set('@all_bonuses', nil)
      end

      it { expect(@result).to be_true }

      it 'should check if has bonus' do
        expect(
           @stockpile.active_bonuses
        ).to include(Bonuses::GrandMother.new.to_hash.merge(count: 1))
      end

      it { expect(@stockpile.reload.regeneration).to eq(Bonuses::GrandMother::REGENERATION) }

      describe 'buy another grand mother' do
        before do
          @stockpile.update_column(:cookies, 650)
          @result = @stockpile.buy_bonus(Bonuses::GrandMother)
          @stockpile.instance_variable_set('@all_bonuses', nil)
        end

        it 'should check if has bonus' do
          expect(
              @stockpile.active_bonuses
          ).to include(Bonuses::GrandMother.new.to_hash.merge(count: 2))
        end
      end

    end

    describe 'fail' do
      before do
        @stockpile.update_column(:cookies, 50)
        @result = @stockpile.buy_bonus(Bonuses::GrandMother)
      end
      it { expect(@result).to be_false }
      it { expect(@stockpile.active_bonuses.size).to eq(0) }
    end
  end

  describe 'regenerate_cookies' do
    before do
      @stockpile1 = create(:stockpile, cookies: 0, regeneration: 5)
      @stockpile2 = create(:stockpile, cookies: 0, regeneration: 10)
      Stockpile.regenerate_cookies
    end

    it { expect(@stockpile1.reload.cookies).to eq(5) }
    it { expect(@stockpile2.reload.cookies).to eq(10) }

  end



end
