require 'spec_helper'

feature 'Hunting' do
  background do
    @hunter = login_hunter
    visit hunting_path
  end

  describe 'getting cookie from own bucket' do
    it 'should add cookie' do
      expect { click_own_bucket }.to change_model(@hunter, :cookies).by(1)
    end

    it 'should redirect back to hunting' do
      expect { click_own_bucket }.to_not change { current_path }
    end
  end

  describe 'Steal cookie from another user' do
    before do
      @target = create(:hunter, cookies: 10)
    end

    it 'should remove cookie from hunter' do
      expect { click_to_steal(@target) }.to change_model(@target, :cookies).by(-1)
    end

    it 'should add cookie to steal bucket' do
      expect { click_to_steal(@target) }.to change_model(steal_bucket, :cookies).by(1)
    end

    it 'should redirect to correct path' do
      expect { click_to_steal(@target) }.to_not change { current_path }
    end
  end

  describe 'getting cookie from steal bucket' do
    before do
      steal_bucket.add(10)
    end

    it 'should add cookie to hunter' do
      expect { click_steal_bucket }.to change_model(@hunter, :cookies).by(1)
    end

    it 'should remove cookie from bucket' do
      expect { click_steal_bucket }.to change_model(steal_bucket, :cookies).by(-1)
    end

    it 'should redirect to correct path' do
      expect { click_steal_bucket }.to_not change { current_path }
    end
  end

  describe 'buy bonus' do
    before do
      @hunter.stockpile.update_column(:cookies, Bonuses::PlusClick::BASIC_PRICE)
      visit hunting_path
    end

    def buy_bonus
      click_on 'bonus_Bonuses::PlusClick'
    end

    it 'should add active bonus item' do
      expect { buy_bonus }.to change { @hunter.reload.active_bonuses.size }.to(1)
    end

    it 'should change click cookies amount' do
      expect { buy_bonus }.to change_model(@hunter.stockpile, :clicks).to(2)
    end
  end


end