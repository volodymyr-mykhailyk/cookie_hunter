require 'spec_helper'

describe Stockpile do
  before do
    @stockpile = create(:stockpile, cookies: 5)
  end

  describe 'Basic behavior' do
    it 'should have 5 cookies from factory' do
      expect(@stockpile.cookies).to eq(5)
    end

    it 'should increase and save cookies on add' do
      expect { @stockpile.add(3) }.to change_model(@stockpile, :cookies).by(3)
    end

    it 'should decrease and save cookies on remove' do
      expect { @stockpile.remove(4) }.to change_model(@stockpile, :cookies).by(-4)
    end

    it 'should return removed amount' do
      expect { @stockpile.remove(4) }.to return_value(-4)
    end

    it 'should remove only available cookies' do
      expect { @stockpile.remove(10) }.to change(@stockpile, :cookies).by(-5)
    end

    it 'should return removed cookies if tried to remove more' do
      expect { @stockpile.remove(10) }.to return_value(-5)
    end

    it 'should return added amount' do
      expect { @stockpile.add(4) }.to return_value(4)
    end

    it 'should allow 0 cookies' do
      expect { @stockpile.remove(5) }.to change_model(@stockpile, :cookies).to(0)
    end

    describe 'add_what_should' do
      before do
        @stockpile.update_column(:clicks, 10)
      end

      it 'should change cookies by 10' do
        expect { @stockpile.add_what_should }.to change_model(@stockpile, :cookies).by(10)
      end
    end

    describe 'remove_what_can' do
      before do
        @stockpile.update_attributes(cookies: 20, saves: 0)
        @another_hunter = create(:hunter)
        @another_hunter.stockpile.update_column(:steals, 10)
      end

      it 'should get 10' do
        expect {
          @result = @stockpile.remove_what_can(@another_hunter)
        }.to change_model(@stockpile, :cookies).by(-10)
        expect(@result).to eq(-10)
      end

      describe 'stockpile has less than hunter can steal' do
        before do
          @stockpile.update_attributes(cookies: 5, saves: 0)
        end

        it 'should get 5' do
          expect {
            @result = @stockpile.remove_what_can(@another_hunter)
          }.to change_model(@stockpile, :cookies).by(-5)
          expect(@result).to eq(-5)
        end
      end

      describe 'stockpile saves 10' do
        before do
          @stockpile.update_attributes(cookies: 15, saves: 10)
        end

        it 'should get 5' do
          expect {
            @result = @stockpile.remove_what_can(@another_hunter)
          }.to change_model(@stockpile, :cookies).by(-5)
          expect(@result).to eq(-5)
        end
      end

      describe 'stockpile saves more than has' do
        before do
          @stockpile.update_attributes(cookies: 15, saves: 100)
        end

        it 'should get 5' do
          expect {
            @result = @stockpile.remove_what_can(@another_hunter)
          }.to change_model(@stockpile, :cookies).by(0)
          expect(@result).to eq(0)
        end
      end

    end



  end

end
