require 'spec_helper'

describe Bonuses::StealBonus do

  describe Bonuses::Trick do
    let(:trick) { create(:trick)}

    it { expect(trick.new_record?).to be_false}

    it 'should delegate recalculate_steals' do
      expect(trick.stockpile.reload.steals).to eq(1)
    end

    it 'should check click when there are two tricks' do
      create(:trick, stockpile: trick.stockpile)
      expect(trick.stockpile.reload.steals).to eq(2)
    end

    it 'should create with only predefined steals' do
      c = Bonuses::Trick.create!(stockpile: create(:stockpile))
      expect(c.steals).to eq(1)
    end
  end

  describe Bonuses::Cheat do
    let(:cheat) { create(:cheat)}

    it { expect(cheat.new_record?).to be_false}

    it 'should delegate recalculate_steals' do
      expect(cheat.stockpile.reload.steals).to eq(5)
    end

    it 'should check click when there are two cheats' do
      create(:cheat, stockpile: cheat.stockpile)
      expect(cheat.stockpile.reload.steals).to eq(10)
    end

    it 'should create with only predefined save' do
      c = Bonuses::Cheat.create!(stockpile: create(:stockpile))
      expect(c.steals).to eq(5)
    end

  end

end