require 'spec_helper'

describe OrdersController do
  before { create_expected_video_lengths! }
  describe 'GET #SHOW' do
    describe 'for users without a order_secure_token cookie' do
      it 'creates a new order' do
        expect {
          get :show
        }.to change{Order.count}
      end

      it 'assigns a new order to @order' do
        get :show
        expect(assigns(:order)).to be_present
      end

      it "writes a cookie called order_secure_token with the value of a new Order's #secure_token" do
        get :show
        expect(cookies[:order_secure_token]).to eq Order.pluck(:secure_token).first
      end

      it 'sets the default order.video_length to 1:30-2 Minutes' do
        get :show
        expect(assigns(:order).video_length).to eq VideoLength.where(name: '1:30-2 Minutes').first
      end
    end

    describe 'for users with an order_secure_token cookie' do
      let!(:order) { create(:order) }
      before { cookies['order_secure_token'] = order.secure_token }

      it 'does not create a new order' do
        expect {
          get :show
        }.not_to change{Order.count}
      end

      it 'assigns an existing order to @order' do
        get :show
        expect(assigns(:order)).to eq order
      end
    end

    describe 'for users with an invalid order_secure_token_cookie' do
      before { cookies['order_secure_token'] = 'forgery!!!!' }

      it 'creates a new order' do
        expect {
          get :show
        }.to change{Order.count}
      end

      it 'assigns the new order to @order' do
        get :show
        expect(assigns(:order)).to be_present
      end

      it 'overwrites the order_secure_token cookie with a valid order token' do
        get :show
        expect(cookies[:order_secure_token]).to eq Order.pluck(:secure_token).first
      end
    end
  end

  describe 'PUT #UPDATE' do
    let!(:order) { create(:order) }
    before { cookies['order_secure_token'] = order.secure_token }

    def test_update(field, value)
      put :update, order: { field => value }
      expect(order.reload[field]).to eq value
    end

    def self.test_update(field, name, value = nil)
      value ||= name
      it "updates order.#{field} to be #{name}" do
        val = value.is_a?(Proc) ? instance_exec(&value) : value
        put :update, order: { field => val }
        expect(order.reload[field]).to eq val
      end
    end

    test_update :project_name, 'New Project Name'
    test_update :instructions, 'Fry the fish at 100 degrees'
    test_update :video_length_id, '2-3 Minutes', -> { create(:three_minute_video).id }
    # Card Holder
    test_update :cardholder_name, 'Steve McQueen'
    test_update :cardholder_address, 'One Way USA'
    test_update :cardholder_city, 'Hinesville'
    test_update :cardholder_state, 'Georgia'
    test_update :cardholder_zipcode, '31313'
    test_update :cardholder_email, 'steve@example.com'
    test_update :cardholder_phone_number, '1 800 94-JENNY'

    it 'accepts order_files_attributes' do
      expect {
        put :update, order: {
            order_files_attributes: [{
                original_filename: 'Kung Fu Hustle',
                uploaded_filename: 'Kung Fu Hustle -- DVD'
            }]
        }
      }.to change{order.order_files.count}.by 1
      order_file = order.order_files.first
      expect(order_file.original_filename).to eq 'Kung Fu Hustle'
      expect(order_file.uploaded_filename).to eq 'Kung Fu Hustle -- DVD'
    end

    it 'redirects to the /order page if the order_secure_token cookie is invalid' do
      cookies['order_secure_token'] = 'forgery'
      put :update, order: { 'foo' => 'bar' }
      expect(subject).to redirect_to(orders_path)
    end

    it 'returns an errors hash if a faulty condition occurs' do
      put :update, order: {
          preparing_for_payment: true,
          cardholder_email: nil
      }
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
      expect(json_response['errors']).to include({ 'cardholder_email' => ["can't be blank"] })
    end

  end

  describe 'GET #CHECKOUT' do
    let!(:order) { create(:order) }
    before { cookies['order_secure_token'] = order.secure_token }

    it 'assigns @order' do
      get :checkout
      expect(assigns(:order)).to eq order
    end
  end

  describe 'POST #SUBMIT_PAYMENT' do
    before { StripeMock.start }
    after { StripeMock.stop }
    let!(:order) { create(:order,
                          cardholder_email: 'steve@gmail.com',
                          video_length: create(:two_minute_video)) }
    before { cookies['order_secure_token'] = order.secure_token }

    it 'assigns @order' do
      post :submit_payment, stripe_token: 'card_void_token'
      expect(assigns(:order)).to eq order
    end

    it 'sets @order.status to Order::Status::PAID on success' do
      post :submit_payment, stripe_token: 'card_void_token'
      expect(order.reload.status).to eq Order::Status::PAID
    end

    it 'sets @order.stripe_customer_id when it is blank' do
      post :submit_payment, stripe_token: 'card_void_token'
      expect(order.reload.stripe_customer_id).to be_present
    end

    it 'does not overwrite @order.stripe_customer_id when it already exists' do
      order.update_attributes(stripe_customer_id: 'Existing Stripe Customer ID')
      post :submit_payment, stripe_token: 'card_void_token'
      expect(order.reload.stripe_customer_id).to eq 'Existing Stripe Customer ID'
    end

    it 'does not call Stripe::Customer when @order.stripe_customer_id exists' do
      order.update_attributes(stripe_customer_id: 'Existing Stripe Customer ID')
      Stripe::Customer.should_not_receive(:create)
      post :submit_payment, stripe_token: 'card_void_token'
    end

    it 'redirects to /success if Order#status ia already Order::Status::PAID' do
      order.update_attributes(status: Order::Status::PAID)
      Stripe::Charge.should_not_receive(:create)
      post :submit_payment, stripe_token: 'card_void_token'
      expect(subject).to redirect_to success_orders_path
    end

    it 'calls Stripe::Charge with the expected variables' do
      order.update_attributes(video_length: create(:three_minute_video), stripe_customer_id: 'Test Customer')
      Stripe::Charge.should_receive(:create).with({
                                                      amount: 14600,
                                                      currency: 'usd',
                                                      customer: 'Test Customer'
                                                  })
      post :submit_payment, stripe_token: 'card_void_token'
    end

    it 'redirects to success_orders_path when successful' do
      post :submit_payment, stripe_token: 'card_void_token'
      expect(subject).to redirect_to success_orders_path
    end

    it 'redirects back to checkout_orders_path if a StripeError occurs' do
      StripeMock.prepare_card_error(:card_declined)
      post :submit_payment, stripe_token: 'card_void_token'
      expect(subject).to redirect_to checkout_orders_path
    end

    it 'creates a flash message if a StripeError occurs' do
      StripeMock.prepare_card_error(:card_declined)
      post :submit_payment, stripe_token: 'card_void_token'
      expect(flash[:stripe_error]).to eq 'The card was declined'
    end

    it 'destroys order_secure_token cookie' do
      post :submit_payment, stripe_token: 'card_void_token'
      expect(cookies['order_secure_token']).to be_nil
    end

    it 'calls AdminMailer.new_order with the current order' do
      AdminMailer.should_receive(:new_order).with(order).and_call_original
      post :submit_payment, stripe_token: 'card_void_token'
    end

    it 'calls UserMailer.new_order with the current order' do
      UserMailer.should_receive(:new_order).with(order).and_call_original
      post :submit_payment, stripe_token: 'card_void_token'
    end
  end

  describe 'POST #ATTACH_COUPON' do
    let!(:order)  { create :order, video_length: create(:two_minute_video) }
    let!(:coupon) { create :coupon, code: 'NASA', name: 'NASA Coupon Centre', discount: 5.00, enabled: true }
    before { cookies['order_secure_token'] = order.secure_token }

    it 'attaches a coupon to an order' do
      post :attach_coupon, coupon: { code: 'NASA' }
      expect(order.reload.coupon).to eq coupon
    end

    it 'only attaches enabled coupons to an order' do
      create(:coupon, code: 'MEAT')
      post :attach_coupon, coupon: { code: 'MEAT' }
      expect(order.reload.coupon).to be_blank
    end

    describe 'when handling Coupon#use_count' do
      let!(:coupon) { create(:coupon, code: 'LIMITED', enabled: true, use_count: 2, discount: 5.00) }
      it 'attaches coupons when Coupon#use_count is less than the number of times the coupon has been used' do
        post :attach_coupon, coupon: { code: 'LIMITED' }
        expect(order.reload.coupon).to be_present
      end

      it 'does not attach a coupon when it has been used more times than its #use_count' do
        2.times { create(:order, coupon: coupon, status: Order::Status::PAID) }
        post :attach_coupon, coupon: { code: 'LIMITED' }
        expect(order.reload.coupon).to be_blank
      end

      describe 'when responding to a failed request' do
        before { 2.times { create :order, status: Order::Status::PAID, coupon: coupon } }
        before { post :attach_coupon, coupon: { code: 'LIMITED' } }
        it { expect(response.status).to eq 400 }
        it 'has a JSON body with errors for a 400 BAD REQUEST response' do
          json = JSON.parse(response.body)
          expect(json).to eq({
                                 'error' => 'Coupon code is no longer available'
                             })
        end
      end
    end


    describe 'when responding to a successful request' do
      before { post :attach_coupon, coupon: { code: 'NASA'} }

      it { expect(response.status).to eq 200 }
      it 'has a JSON body with the discount for 200 OK response' do
        json = JSON.parse(response.body)
        expect(json).to eq({
          'name' => 'NASA Coupon Centre',
          'discount' => 5.0,
          'new_order_cost' => 90.0
        })
      end
    end

    describe 'when responding to a failed request' do
      before { post :attach_coupon, coupon: { code: nil } }
      it { expect(response.status).to eq 400 }
      it 'has a JSON body with errors for a 400 BAD REQUEST response' do
        post :attach_coupon, coupon: { code: 'INVALID' }
        json = JSON.parse(response.body)
        expect(json).to eq({
            'error' => 'Coupon code not found'
        })
      end
    end
  end
end
