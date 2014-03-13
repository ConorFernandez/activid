require 'spec_helper'

describe Order do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'secure tokens' do
    it 'should generate a secure token before save' do
      order = Order.create! status: 'footie PJs'
      expect(order.secure_token).not_to be_blank
    end
  end
end