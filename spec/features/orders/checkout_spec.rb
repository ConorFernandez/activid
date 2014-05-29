require 'spec_helper'

describe 'The Checkout Page ->', js: true, vcr: true do
  subject { page }
  before { create_expected_video_lengths! }
  before { visit '/orders'; visit '/orders/checkout' }

  it 'I can go back by clicking the Go Back button' do
    click_link 'edit my order'
    expect(current_path).to eq '/orders'
  end

  it 'I can submit an order with a valid credit card' do
    fill_in 'Email', with: 'guy@example.com'
    fill_in 'Phone', with: '1-800-94-JENNY'

    fill_in 'Card Number', with: '4242424242424242'
    fill_in 'Card Exp Month', with: '01'
    fill_in 'Card Exp Year', with: '2020'
    fill_in 'CVC', with: '123'

    click_button 'Complete Order'
    wait_until { current_path == '/orders/success' }
  end

  it 'I can create a new order after checking out' do
    visit '/orders'

    fill_in 'order_project_name', with: 'Fighting The Lawman'
    click_link 'Proceed to Checkout'

    fill_in 'Email', with: 'guy@example.com'
    fill_in 'Phone', with: '1-800-94-JENNY'

    fill_in 'Card Number', with: '4242424242424242'
    fill_in 'Card Exp Month', with: '01'
    fill_in 'Card Exp Year', with: '2020'
    fill_in 'CVC', with: '123'

    click_button 'Complete Order'
    wait_until { current_path == '/orders/success' }

    visit '/orders'
    wait_until { current_path == '/orders' } # Oh boy, more timing issues with Capybara. Surprise.
    expect(page).not_to have_field 'order_project_name', with: 'Fighting The Lawman'
  end

  it 'I can see a card declined error if I submit an order with an invalid card' do
    fill_in 'Email', with: 'guy@example.com'
    fill_in 'Phone', with: '1-800-94-JENNY'

    fill_in 'Card Number', with: '4000000000000002'
    fill_in 'Card Exp Month', with: '01'
    fill_in 'Card Exp Year', with: '2020'
    fill_in 'CVC', with: '123'

    click_button 'Complete Order'
    wait_for_ajax
    expect(page).to have_text 'Your card was declined.'
  end

  it 'I can see a form error if I neglect to enter my email address' do
    click_button 'Complete Order'
    expect(page).to have_text "cardholder_email can't be blank"
  end

  it 'I can see a payment error if I enter an invalid card number' do
    fill_in 'Email', with: 'guy@example.com'
    fill_in 'Card Number', with: 'Gobbly Gook'

    click_button 'Complete Order'
    expect(page).to have_text 'Your card number is incorrect'
  end

  describe 'Coupons -->' do
    let!(:coupon) { create :coupon, code: 'NASA', name: 'NASA Coupon Centre', discount: 5.00, enabled: true }
    let!(:unusable_coupon) { create :coupon, code: 'FREE', name: 'Free Coupon', discount: 100.00, enabled: true, use_count: 0 }

    it 'I can attach a coupon to an order' do
      within('#coupon_form') do
        fill_in 'coupon_code', with: 'NASA'
        click_button 'Use Coupon'
      end
      expect(page).to have_text 'NASA Coupon Centre'
      expect(page).to have_text '-$5.00'
      expect(page).to have_text '$90.00'
    end

    it 'I can see an error message if I supply an invalid coupon code' do
      within('#coupon_form') do
        fill_in 'coupon_code', with: 'Quackers Big Day'
        click_button 'Use Coupon'
      end
      expect(page).to have_text 'Coupon code not found'
    end

    it 'I can see an error message if the coupon I want to use is unavailable' do
      within('#coupon_form') do
        fill_in 'coupon_code', with: 'FREE'
        click_button 'Use Coupon'
      end
      expect(page).to have_text 'Coupon code is no longer available'
    end

    it 'I can see a message if I have already used a coupon for this order' do
      Order.last.update_attributes(coupon: coupon)
      visit '/orders/checkout'

      expect(page).to have_text "NASA Coupon Centre"
    end
  end
end
