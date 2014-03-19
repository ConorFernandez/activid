require 'spec_helper'

describe OrdersController do
  describe 'GET #SHOW' do
    describe 'for users with a order_secure_token cookie' do
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

    def self.test_update(field, value)
      it "updates order.#{field} to be #{value}" do
        put :update, order: { field => value }
        expect(order.reload[field]).to eq value
      end
    end

    test_update :project_name, 'New Project Name'
    test_update :instructions, 'Fry the fish at 100 degrees'
    test_update :video_length, '2 Minutes'
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
      expect(json_response).to include({ 'errors' => { 'cardholder_email' => ["can't be blank"] }  })
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
end