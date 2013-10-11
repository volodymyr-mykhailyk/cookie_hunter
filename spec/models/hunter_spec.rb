require 'spec_helper'

describe Hunter do
  describe 'Factory' do
    before do
      @hunter = create(:hunter, cookies: 5)
    end

    it 'should add cookies to stockpile' do
      expect(@hunter.cookies).to eq(5)
    end
  end
end
