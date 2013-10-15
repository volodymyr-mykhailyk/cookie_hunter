require 'spec_helper'

describe Bonuses::SaveBonus do

  describe Bonuses::CookieBox do
    let(:cookie_box) { create(:cookie_box)}

    it { expect(cookie_box.new_record?).to be_false}

    it 'should delegate recalculate_saves' do
      expect(cookie_box.stockpile.reload.saves).to eq(1000)
    end

    it 'should check click when there are two cookie_boxes' do
      create(:cookie_box, stockpile: cookie_box.stockpile)
      expect(cookie_box.stockpile.reload.saves).to eq(2000)
    end

    it 'should create with only predefined save' do
      c = Bonuses::CookieBox.create!(stockpile: create(:stockpile))
      expect(c.saves).to eq(1000)
    end
  end

  describe Bonuses::BreadPlate do
    let(:bread_plate) { create(:bread_plate)}

    it { expect(bread_plate.new_record?).to be_false}

    it 'should delegate recalculate_saves' do
      expect(bread_plate.stockpile.reload.saves).to eq(5000)
    end

    it 'should check click when there are two bread_plates' do
      create(:bread_plate, stockpile: bread_plate.stockpile)
      expect(bread_plate.stockpile.reload.saves).to eq(10000)
    end

    it 'should create with only predefined save' do
      c = Bonuses::BreadPlate.create!(stockpile: create(:stockpile))
      expect(c.saves).to eq(5000)
    end

  end

end