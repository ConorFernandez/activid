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
end