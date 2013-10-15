require 'spec_helper'

describe Bonuses::ClickBonus do

  describe Bonuses::PlusClick do
    let(:plus_click) { create(:plus_click)}

    it { expect(plus_click.new_record?).to be_false}

    it 'should delegate recalculate_regeneration' do
      expect(plus_click.stockpile.reload.clicks).to eq(2)
    end

    it 'should check click when there are two bonuses' do
      create(:plus_click, stockpile: plus_click.stockpile)
      expect(plus_click.stockpile.reload.clicks).to eq(3)
    end

    it 'should create with only predefined regeneration' do
      c = Bonuses::PlusClick.create!(stockpile: create(:stockpile))
      expect(c.clicks).to eq(1)
    end
  end

  describe Bonuses::DoubleClick do
    let(:double_click) { create(:double_click)}

    it { expect(double_click.new_record?).to be_false}

    describe 'clicks count' do
      before do
        @stockpile = create(:stockpile)
        2.times { create(:plus_click, stockpile: @stockpile) }
      end

      it { expect(@stockpile.reload.clicks).to eq(3) }

      it 'should check clicks' do
         double_click = create(:double_click, stockpile: @stockpile)
         expect(double_click.clicks).to eq(3)
      end

      it 'should check clicks on stockpile' do
        create(:double_click, stockpile: @stockpile)
        expect(@stockpile.reload.clicks).to eq(6)
      end

      it 'should check clicks on stockpile with two double_clicks' do
        2.times { create(:double_click, stockpile: @stockpile) }
        expect(@stockpile.reload.clicks).to eq(12)
      end
    end

  end

end