require 'spec_helper'

describe 'main' do
  describe 'add Klass#delta_attributes method' do
    it 'should define delta_attributes_method' do
      expect(Bucket).to respond_to(:delta_attributes)
    end

    it 'should set attributes to @_delta_attributes' do
      attrs = Bucket.instance_variable_get('@_delta_attributes')
      expect(attrs).to include('cookies')
    end
  end

  describe 'Arel monkey patching' do
    before do
      @bucket = create(:bucket)
      @bucket.cookies += 2
      @bucket.cookies *= 5
    end

    it 'should set cookies' do
      @bucket.save
      expect(@bucket.reload.cookies).to eql(10)
    end

    it 'should check log' do
      Rails.logger.should_receive(:debug).with(/\"cookies\" = \"cookies\" \+ \$1/)
      @bucket.save
    end

  end

  describe 'Multi threaded/process case' do
    before do
      @bucket = create(:bucket)
    end

    it 'should change @bucket in different threads' do
      expect {
        several_threads([1, 2, 3]) do |amount|
          @bucket.reload.cookies += amount
          @bucket.save
        end
      }.to change_model(@bucket, :cookies).by(6)
    end

    it 'should change @bucket in different processes' do
      expect {
        several_processes([1, 2, 3]) do |amount|
          @bucket.reload.cookies += amount
          @bucket.save
        end
      }.to change_model(@bucket, :cookies).by(6)
    end

    describe 'turn off delta_attributes' do
      before do
        Bucket.instance_variable_set('@_delta_attributes', nil)
      end

      it 'should change @bucket in different threads' do
        several_threads([1, 2, 3]) do |amount|
          bucket = Bucket.find(@bucket.id)
          bucket.cookies += amount
          sleep(0.05)
          bucket.save
        end
        expect(@bucket.reload.cookies).to be < 6
      end

      it 'should change @bucket in different processes' do
        several_processes([1, 2, 3]) do |amount|
          bucket = Bucket.find(@bucket.id)
          bucket.cookies += amount
          sleep(0.05)
          bucket.save
        end
        expect(@bucket.reload.cookies).to be < 6
      end
    end
  end


end