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
      click_on "available_bonus_Bonuses::PlusClick"
      @hunter.stockpile.instance_variable_set('@all_bonuses', nil)
    end

    it 'should check bonus' do
      expect(@hunter.reload.active_bonuses.size).to eq(1)
    end

    it 'should check regeneration' do
      expect(@hunter.stockpile.reload.clicks).to eq(2)
    end
  end


end