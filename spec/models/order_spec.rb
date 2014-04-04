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

    it 'validates inclusion of video_length when preparing_for_payment == true' do
      order = build(:order, preparing_for_payment: true)
      order.should validate_presence_of :video_length_id
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
      order = create(:order, status: Order::Status::PAID)
      expect(order.paid?).to be_true
    end

    it 'should not be true if status != Order::Status::Paid' do
      order = create(:order, status: Order::Status::DRAFT)
      expect(order.paid?).not_to be_true
    end
  end

  describe '#order_cost' do
    it 'returns the cost of an order in pennies based on video_length' do
      order = create(:order, video_length: create(:three_minute_video))
      expect(order.order_cost).to eq Money.new(14600, 'USD')
    end

    it 'raises an error if video_length is nil' do
      order = create(:order, video_length: nil)
      expect {
        order.order_cost
      }.to raise_error('video_length cannot be nil!')
    end
  end

  describe 'Order.video_cost' do
    it 'returns the cost of an order in pennies based on video_length' do
      expect(Order.video_cost(create(:three_minute_video))).to eq Money.new(14600, 'USD')
    end

    it 'raises an error if video_length is nil' do
      expect {
        Order.video_cost(nil)
      }.to raise_error('video_length cannot be nil!')
    end
  end
end