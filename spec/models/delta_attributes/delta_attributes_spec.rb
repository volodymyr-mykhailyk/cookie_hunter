require 'spec_helper'

describe 'main' do
  before do
    Bucket.send(:delta_attributes, :cookies)
  end

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
    end

    it 'should ' do
      @bucket.cookies += 2
      @bucket.cookies *= 5
      Rails.logger.should_receive(:debug).with(/\"cookies\" = \"cookies\" \+ \$1/)
      @bucket.save
      expect(@bucket.reload.cookies).to eql(10)
    end

  end


end