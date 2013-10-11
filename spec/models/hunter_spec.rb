require 'spec_helper'

describe Hunter do
  describe 'Factory' do
    before do
      @hunter = create(:hunter)
    end

    it 'should add cookies to stockpile' do
      expect(@hunter.cookies).to be > 0
    end
  end
end
