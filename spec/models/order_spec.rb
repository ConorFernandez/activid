require 'spec_helper'

describe Order do
  describe 'validations' do
    it { should validate_presence_of :status }
    it 'should validate email presence if preparing_for_payment == true' do
      order = build(:order, preparing_for_payment: true)
      order.should validate_presence_of :cardholder_email
    end
    it 'should not validate email presence if preparing_for_payment != true' do
      order = create(:order)
      order.should_not validate_presence_of :cardholder_email
    end
  end

  describe 'secure tokens' do
    it 'should generate a secure token before save' do
      order = Order.create! status: 'footie PJs'
      expect(order.secure_token).not_to be_blank
    end
  end
end