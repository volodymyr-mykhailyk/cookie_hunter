require 'spec_helper'

describe Stockpile do
  before do
    @stockpile = create(:stockpile, cookies: 20, clicks: 5, steals: 6, saves: 7)
  end

  describe 'Basic behavior' do
    it 'should have 5 cookies from factory' do
      expect(@stockpile.cookies).to eq(20)
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
      @stockpile.stub(:unsafe_cookies).and_return 3
      expect { @stockpile.remove(10) }.to change(@stockpile, :cookies).by(-3)
    end

    it 'should return removed cookies if tried to remove more' do
      expect { @stockpile.remove(30) }.to return_value(-13)
    end

    it 'should return added amount' do
      expect { @stockpile.add(4) }.to return_value(4)
    end

    describe 'add what should' do
      it 'should add cookies by amount of cookies per click' do
        expect { @stockpile.add_what_should }.to change_model(@stockpile, :cookies).by(5)
      end
    end

    describe 'get from' do
      before do
        @bucket = create(:bucket, cookies: 6)
      end

      it 'should add cookies by amount of cookies per click ' do
        expect { @stockpile.get_from(@bucket) }.to change_model(@stockpile, :cookies).by(5)
      end

      it 'should add cookies by amount of unsafe cookies in bucket' do
        @bucket.stub(:unsafe_cookies).and_return 3
        expect { @stockpile.get_from(@bucket) }.to change_model(@stockpile, :cookies).by(3)
      end

      it 'should remove from target amount of cookies per click' do
        expect { @stockpile.get_from(@bucket) }.to change_model(@bucket, :cookies).by(-5)
      end

      it 'should remove from target amount of unsafe cookies' do
        @bucket.stub(:unsafe_cookies).and_return 3
        expect { @stockpile.get_from(@bucket) }.to change_model(@bucket, :cookies).by(-3)
      end

      it 'should return amount of transferred cookies' do
        @bucket.remove(2)
        @stockpile.get_from(@bucket).should == 4
      end
    end

    describe 'steal by' do
      before do
        @hunter = create(:hunter)
        @hunter.stockpile.update_attribute(:steals, 5)
      end

      it 'should remove stolen cookies from stockpile' do
        expect { @stockpile.steal_by(@hunter) }.to change_model(@stockpile, :cookies).by(-5)
      end

      it 'should remove only available cookies from stockpile' do
        @stockpile.stub(:unsafe_cookies).and_return 3
        expect { @stockpile.steal_by(@hunter) }.to change_model(@stockpile, :cookies).by(-3)
      end

      it 'should add stolen cookies to steal bucket stockpile' do
        expect { @stockpile.steal_by(@hunter) }.to change_model(StealBucket.instance, :cookies).by(5)
      end

      it 'should add only available cookies to steal bucket stockpile' do
        @stockpile.stub(:unsafe_cookies).and_return 3
        expect { @stockpile.steal_by(@hunter) }.to change_model(StealBucket.instance, :cookies).by(3)
      end

      it 'should return transfered cookies amount' do
        @stockpile.stub(:unsafe_cookies).and_return 3
        expect { @stockpile.steal_by(@hunter) }.to return_value(3)
      end
    end

  end

end
