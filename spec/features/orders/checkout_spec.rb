require 'spec_helper'

describe 'The Checkout Page ->', js: true do
  subject { page }
  before { visit '/orders'; visit '/orders/checkout' }

  it 'I can go back by clicking the Go Back button' do
    click_link 'Go Back'
    expect(current_path).to eq '/orders'
  end
end