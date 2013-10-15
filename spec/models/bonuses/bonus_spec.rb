require 'spec_helper'

describe Bonuses::Bonus do

  describe 'price_for' do
    before do
      @bonus = create(:grand_mother)
      @stockpile = create(:stockpile)
    end

    it 'should check the basic price' do
      expect(@bonus.price_for(@stockpile)).to eq(Bonuses::GrandMother::BASIC_PRICE)
    end

    it 'should check the new price' do
      @stockpile = @bonus.stockpile
      expect(@bonus.price_for(@stockpile)).to eq(2 * Bonuses::GrandMother::BASIC_PRICE)
    end
  end

end
