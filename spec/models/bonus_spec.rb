require 'spec_helper'

describe Bonus do
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
