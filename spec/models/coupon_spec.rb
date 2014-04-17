require 'spec_helper'


describe Coupon do

  describe '#is_usable?' do
    it 'is true when #use_count is null' do
      coupon = create :coupon, name: 'test', use_count: nil
      expect(coupon.is_usable?).to eq true
    end

    it 'is true when the number of times used is < #use_count' do
      coupon = create :coupon, name: 'test', use_count: 2
      create :order, coupon: coupon, status: Order::Status::PAID
      expect(coupon.is_usable?).to eq true
    end

    it 'is false when the number of times used is >= #use_count' do
      coupon = create :coupon, name: 'test', use_count: 2
      2.times { create :order, coupon: coupon, status: Order::Status::PAID }
      expect(coupon.is_usable?).to eq false
    end
  end
end