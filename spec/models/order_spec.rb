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

  describe '#paid?' do
    it 'should be true if status == Order::Status::Paid' do
      order = create(:order, status: Order::Status::Paid)
      expect(order.paid?).to be_true
    end

    it 'should not be true if status != Order::Status::Paid' do
      order = create(:order, status: Order::Status::Draft)
      expect(order.paid?).not_to be_true
    end
  end

  describe '#order_cost' do
    it 'returns the cost of an order in pennies based on video_length' do
      order = create(:order, video_length: Order::VIDEO_LENGTHS)
    end

    it 'raises an error if video_length is an unknown value' do
      order = create(:order, video_length: 'No Minutes LOL')
      expect {
        order.video_length
      }.to raise('Video Length is unexpected! (Got: No Minutes LOL)')
    end
  end
end