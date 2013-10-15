require 'spec_helper'

describe Bonuses::RegenerationBonus do

  describe Bonuses::GrandMother do
    let(:grand_mother) { create(:grand_mother)}

    it { expect(grand_mother.new_record?).to be_false}

    it 'should delegate recalculate_regeneration' do
      Stockpile.any_instance.should_receive(:recalculate_regeneration)
      grand_mother
    end

    it 'should create with only predefined regeneration' do
      c = Bonuses::GrandMother.create!(stockpile: create(:stockpile))
      expect(c.regeneration).to eq(5)
    end
  end

  describe Bonuses::Stove do
    let(:stove) { create(:stove)}

    it { expect(stove.new_record?).to be_false}

    it 'should delegate recalculate_regeneration' do
      Stockpile.any_instance.should_receive(:recalculate_regeneration)
      stove
    end

    it 'should create with only predefined regeneration' do
      c = Bonuses::Stove.create!(stockpile: create(:stockpile))
      expect(c.regeneration).to eq(10)
    end
  end

end