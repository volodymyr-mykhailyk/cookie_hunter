require 'spec_helper'

describe 'Bonuses' do


  describe Bonus do

    it 'should have ClickBonus in TYPES' do
      expect(Bonus::TYPES).to include(ClickBonus)
    end

    describe 'get_available_bonuses' do
      it 'should find ClickBonus' do
        bonuses = Bonus.get_available_bonuses(20)
        expect(bonuses).to include(ClickBonus.new)
      end

      it 'should not find ClickBonus' do
        bonuses = Bonus.get_available_bonuses(5)
        expect(bonuses).to_not include(ClickBonus.new)
      end
    end

  end

  describe ClickBonus do
    let(:click_bonus) { create(:click_bonus)}

    it { expect(click_bonus.new_record?).to be_false}

    it 'should delegate recalculate_regeneration' do
      Stockpile.any_instance.should_receive(:recalculate_regeneration)
      click_bonus
    end

    it 'should create with only predefined regeneration' do
      c = ClickBonus.create!(stockpile: create(:stockpile))
      expect(c.regeneration).to eq(1)
    end
  end
end
