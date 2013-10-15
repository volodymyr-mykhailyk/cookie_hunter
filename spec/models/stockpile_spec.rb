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

    it 'should return added amount' do
      expect { @stockpile.add(4) }.to return_value(4)
    end

    it 'should allow 0 cookies' do
      expect { @stockpile.remove(5) }.to change_model(@stockpile, :cookies).to(0)
    end

    it 'should return 0 if result cookies less then 0' do
      expect { @stockpile.remove(6) }.to return_value(0)
    end

    it 'should not change cookies if result cookies less then 0' do
      expect { @stockpile.remove(6) }.to_not change_model(@stockpile, :cookies)
    end

    describe 'bonuses' do
      describe 'buy bonus' do
        before do
          @stockpile.update_column(:cookies, 150)
          @result = @stockpile.buy_bonus(ClickBonus)
        end

        it { expect(@result).to be_true }

        it 'should check if has bonus' do
          expect(
            @stockpile.active_bonuses
          ).to include(ClickBonus.new.to_hash.merge(count: 1))
        end

        it { expect(@stockpile.reload.regeneration).to eq(1) }
      end

      describe 'fail' do
        before do
          @stockpile.update_column(:cookies, 50)
          @result = @stockpile.buy_bonus(ClickBonus)
        end
        it { expect(@result).to be_false }
        it { expect(@stockpile.active_bonuses.size).to eq(0) }
      end
    end

    describe 'regenerate_cookies' do
      before do
        @stockpile1 = create(:stockpile, cookies: 0, regeneration: 5)
        @stockpile2 = create(:stockpile, cookies: 0, regeneration: 10)
        Stockpile.regenerate_cookies
      end

      it { expect(@stockpile1.reload.cookies).to eq(5) }
      it { expect(@stockpile2.reload.cookies).to eq(10) }

    end

  end


  describe 'locking strategies' do
    before do
      @strategy = double(:lock_strategy, perform: false)
      @stockpile.stub(:change_lock_strategy).and_return @strategy
    end

    it 'should use lock strategy for add' do
      @strategy.should_receive(:perform).and_yield
      expect { @stockpile.add(3) }.to change_model(@stockpile, :cookies).by(3)
    end

    it 'should use lock strategy for remove' do
      @strategy.should_receive(:perform).and_yield
      expect { @stockpile.remove(3) }.to change_model(@stockpile, :cookies).by(-3)
    end

    it 'should not change value if not yielded' do
      expect { @stockpile.remove(3) }.to_not change_model(@stockpile, :cookies)
    end

    it 'should return 0 if not yielded' do
      expect { @stockpile.add(3) }.to return_value(0)
    end
  end
end
