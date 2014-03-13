require 'spec_helper'

describe Order do
  describe 'validations' do

  end

  describe 'secure tokens' do
    it 'should generate a secure token before save' do
      order = Order.create!
      expect(order.secure_token).not_to be_blank
    end
  end
end